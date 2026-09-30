{
  inputs,
  ...
}:
{
  # Nginx Reverse Proxy with automated Tailscale Let's Encrypt TLS certificates

  flake.modules.nixos.tailscale-proxy =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.tailscale-proxy;
      domain = inputs.self.lib.tailnet.domain;
      fqdn = "${config.networking.hostName}.${domain}";
      certDir = "/var/lib/tailscale-certs";
    in
    {
      key = "tailscale-proxy";

      options.tailscale-proxy = {
        fqdn = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = fqdn;
          description = "Tailnet FQDN for this host";
        };

        proxiedServices = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                path = lib.mkOption {
                  type = lib.types.str;
                  description = "URL path location to proxy (e.g. '/' or '/adguard')";
                };
                forwardTo = lib.mkOption {
                  type = lib.types.str;
                  description = "Target upstream address";
                };
                proxyWebsockets = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable WebSocket proxying";
                };
                maxBodySize = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = "10m";
                  description = "client_max_body_size (null for unlimited)";
                };
              };
            }
          );
          default = { };
          description = "Services to expose via Tailscale HTTPS reverse proxy";
        };
      };

      config = {
        services.nginx = {
          enable = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          recommendedOptimisation = true;
          recommendedGzipSettings = true;

          virtualHosts.${fqdn} = {
            forceSSL = true;
            sslCertificate = "${certDir}/${fqdn}.crt";
            sslCertificateKey = "${certDir}/${fqdn}.key";
            locations =
              cfg.proxiedServices
              |> lib.attrValues
              |> map (service:
                let
                  basePath = lib.removeSuffix "/" service.path;
                  locationPath = if basePath == "" then "/" else "${basePath}/";

                  proxyLocation = {
                    name = locationPath;
                    value = {
                      proxyPass = service.forwardTo;
                      proxyWebsockets = service.proxyWebsockets;
                      extraConfig = ''
                        proxy_read_timeout 86400s;
                        proxy_send_timeout 86400s;
                        client_max_body_size ${if service.maxBodySize != null then service.maxBodySize else "0"};
                      '';
                    };
                  };

                  redirectLocation = lib.optional (basePath != "") {
                    name = "= ${basePath}";
                    value = {
                      return = "308 ${basePath}/";
                    };
                  };
                in
                [ proxyLocation ] ++ redirectLocation
              )
              |> lib.flatten
              |> lib.listToAttrs;
          };
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        systemd.services.tailscale-cert = {
          description = "Fetch and renew Tailscale TLS certificate for Nginx";
          after = [ "tailscaled.service" ];
          wants = [ "tailscaled.service" ];
          before = [ "nginx.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "fetch-tailscale-certs" ''
              mkdir -p ${certDir}
              chown root:nginx ${certDir}
              chmod 750 ${certDir}

              certFile="${certDir}/${fqdn}.crt"
              keyFile="${certDir}/${fqdn}.key"
              if [ ! -f "$certFile" ]; then
                # Create temporary self-signed cert so Nginx can start before Tailscale login
                ${pkgs.openssl}/bin/openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
                  -keyout "$keyFile" -out "$certFile" \
                  -subj "/CN=${fqdn}"
              fi
              chmod 640 "$certFile" "$keyFile"
              chown root:nginx "$certFile" "$keyFile"

              # Attempt to fetch genuine Let's Encrypt cert from Tailscale
              if ${pkgs.tailscale}/bin/tailscale status --json | ${pkgs.jq}/bin/jq -e '.BackendState == "Running"' >/dev/null 2>&1; then
                if ${pkgs.tailscale}/bin/tailscale cert --cert-file "$certFile" --key-file "$keyFile" "${fqdn}"; then
                  chmod 640 "$certFile" "$keyFile"
                  chown root:nginx "$certFile" "$keyFile"
                fi
              fi

              if ${pkgs.systemd}/bin/systemctl is-active --quiet nginx.service; then
                ${pkgs.systemd}/bin/systemctl reload --no-block nginx.service || true
              fi
            '';
          };
        };

        systemd.timers.tailscale-cert = {
          description = "Timer to renew Tailscale TLS certificate daily";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };
        };

        systemd.services.nginx = {
          after = [ "tailscale-cert.service" ];
          wants = [ "tailscale-cert.service" ];
        };

        impermanence.persistedDirectories = [
          "/var/lib/tailscale-certs"
        ];
      };
    };
}
