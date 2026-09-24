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
      primaryFqdn = "${config.networking.hostName}.${domain}";
      certDir = "/var/lib/tailscale-certs";
      servicesByFqdn =
        cfg.proxiedServices
        |> lib.attrValues
        |> lib.groupBy (
          service:
          if service.subdomain != null && service.subdomain != "" then
            "${service.subdomain}.${primaryFqdn}"
          else
            primaryFqdn
        );
    in
    {
      options.tailscale-proxy = {
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
                subdomain = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Optional subdomain (e.g. 'nas' -> 'nas.claptrap.tail0fdbb0.ts.net')";
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

          virtualHosts =
            servicesByFqdn
            |> lib.mapAttrs (
              fqdn: services: {
                forceSSL = true;
                sslCertificate = "${certDir}/${fqdn}.crt";
                sslCertificateKey = "${certDir}/${fqdn}.key";
                locations =
                  services
                  |> map (service: {
                    name = service.path;
                    value = {
                      proxyPass = service.forwardTo;
                      proxyWebsockets = service.proxyWebsockets;
                      extraConfig = ''
                        proxy_read_timeout 86400s;
                        proxy_send_timeout 86400s;
                        client_max_body_size ${if service.maxBodySize != null then service.maxBodySize else "0"};
                      '';
                    };
                  })
                  |> lib.listToAttrs;
              }
            );
        };

        networking.firewall.allowedTCPPorts = [
          80
          443
        ];

        systemd.services.tailscale-cert = {
          description = "Fetch and renew Tailscale TLS certificates for Nginx";
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

              ${
                servicesByFqdn
                |> lib.attrNames
                |> lib.concatMapStringsSep "\n" (fqdn: ''
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
                '')
              }

              if ${pkgs.systemd}/bin/systemctl is-active --quiet nginx.service; then
                ${pkgs.systemd}/bin/systemctl reload --no-block nginx.service || true
              fi
            '';
          };
        };

        systemd.timers.tailscale-cert = {
          description = "Timer to renew Tailscale TLS certificates daily";
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
