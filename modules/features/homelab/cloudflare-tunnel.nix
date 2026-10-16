{
  inputs,
  ...
}:
{
  # Cloudflare Tunnel - Expose local services securely via Cloudflare Tunnels
  # https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/

  flake.modules.nixos.cloudflare-tunnel =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.cloudflare-tunnel;

      fallbackServer = pkgs.writers.writeRust "cloudflare-fallback-server" { } ''
        use std::io::{Read, Write};
        use std::net::TcpListener;

        fn main() {
            let listener = TcpListener::bind("127.0.0.1:8085").expect("Failed to bind fallback server port");
            println!("Cloudflare fallback server running on 127.0.0.1:8085");
            for stream in listener.incoming() {
                if let Ok(mut stream) = stream {
                    let mut buf = [0; 1024];
                    let _ = stream.read(&mut buf);
                    let body = r#"<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>michaeldyer.dev</title>
  <style>
    body {
      background-color: #0d1117;
      color: #c9d1d9;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .card {
      background: #161b22;
      border: 1px solid #30363d;
      border-radius: 12px;
      padding: 2.5rem 3rem;
      text-align: center;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.5);
    }
    h1 {
      margin: 0 0 0.5rem 0;
      font-size: 1.8rem;
      color: #58a6ff;
    }
    p {
      margin: 0;
      color: #8b949e;
      font-size: 1rem;
    }
    .status {
      display: inline-block;
      margin-top: 1.5rem;
      padding: 0.25rem 0.75rem;
      background: rgba(46, 160, 67, 0.15);
      color: #3fb950;
      border: 1px solid rgba(46, 160, 67, 0.4);
      border-radius: 20px;
      font-size: 0.85rem;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>michaeldyer.dev</h1>
    <p>Welcome! System operational.</p>
    <div class="status">&#9679; Cloudflare Tunnel Active</div>
  </div>
</body>
</html>"#;
                    let response = format!(
                        "HTTP/1.1 200 OK\r\nContent-Type: text/html; charset=utf-8\r\nContent-Length: {}\r\nConnection: close\r\n\r\n{}",
                        body.len(),
                        body
                    );
                    let _ = stream.write_all(response.as_bytes());
                }
            }
        }
      '';
    in
    {
      key = "cloudflare-tunnel";

      options.cloudflare-tunnel = {
        domain = lib.mkOption {
          type = lib.types.str;
          description = "Base domain for Cloudflare Tunnel (e.g. 'michaeldyer.dev')";
        };

        tunnelName = lib.mkOption {
          type = lib.types.str;
          description = "Name of the Cloudflare tunnel (e.g. 'claptrap')";
        };

        secretName = lib.mkOption {
          type = lib.types.str;
          description = "SOPS secret key name containing tunnel credentials JSON";
        };

        proxiedServices = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule (
              { config, ... }:
              let
                subConfig = config;
              in
              {
                options = {
                  subdomain = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Optional subdomain (e.g. 'vault' -> 'vault.michaeldyer.dev')";
                  };

                  path = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Optional path filter (e.g. '/vault/*')";
                  };

                  forwardTo = lib.mkOption {
                    type = lib.types.str;
                    description = "Target upstream address (e.g. 'http://127.0.0.1:8222')";
                  };

                  fqdn = lib.mkOption {
                    type = lib.types.str;
                    readOnly = true;
                    description = "Full calculated FQDN for this proxied service";
                  };

                  url = lib.mkOption {
                    type = lib.types.str;
                    readOnly = true;
                    description = "Full calculated HTTPS URL for this proxied service";
                  };
                };

                config = {
                  fqdn =
                    if subConfig.subdomain != null && subConfig.subdomain != "" then
                      "${subConfig.subdomain}.${cfg.domain}"
                    else
                      cfg.domain;

                  url = "https://${subConfig.fqdn}${
                    if subConfig.path != null then subConfig.path else ""
                  }";
                };
              }
            )
          );
          default = { };
          description = "Services to expose via Cloudflare Tunnel ingress";
        };
      };

      config = {
        sops.secrets.${cfg.secretName} = {
          mode = "0400";
          owner = "root";
        };

        systemd.services.cloudflare-fallback-site = {
          description = "Cloudflare Tunnel Fallback Static Site (Rust)";
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${fallbackServer}";
            Restart = "always";
            RestartSec = "3s";
            DynamicUser = true;
          };
        };

        services.cloudflared = {
          enable = true;
          tunnels.${cfg.tunnelName} = {
            credentialsFile = config.sops.secrets.${cfg.secretName}.path;
            default = "http://127.0.0.1:8085";
            ingress =
              cfg.proxiedServices
              |> lib.mapAttrs' (
                _: service:
                  lib.nameValuePair service.fqdn (
                    if service.path != null then
                      {
                        service = service.forwardTo;
                        path = service.path;
                      }
                    else
                      service.forwardTo
                  )
              );
          };
        };
      };
    };
}
