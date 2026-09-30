{
  inputs,
  ...
}:
{
  # Vaultwarden - Lightweight Bitwarden-compatible password manager server
  # https://github.com/dani-garcia/vaultwarden

  flake.modules.nixos.vaultwarden =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.vaultwarden;
    in
    {
      key = "vaultwarden";

      imports = with inputs.self.modules.nixos; [
        tailscale-proxy
      ];

      options.vaultwarden = {
        urlPath = lib.mkOption {
          type = lib.types.str;
          default = "/vault";
          description = "URL path location for Tailscale HTTPS proxy (e.g. '/vault')";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8222;
          description = "Internal Rocket server port for Vaultwarden";
        };

        maxBodySize = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = "525m";
          description = "Maximum client upload size for vault attachments and Send feature";
        };

        environmentFile = lib.mkOption {
          type = lib.types.listOf lib.types.path;
          default = [ ];
          description = "Runtime environment files containing secrets (e.g. ADMIN_TOKEN, SMTP_PASSWORD)";
        };
      };

      config = {
        services.vaultwarden = {
          enable = true;
          configureNginx = false;
          environmentFile = cfg.environmentFile;
          config = {
            DOMAIN = "https://${config.tailscale-proxy.fqdn}${cfg.urlPath}";
            ENABLE_WEBSOCKET = true;
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = cfg.port;
          };
        };

        tailscale-proxy.proxiedServices.vaultwarden = {
          path = cfg.urlPath;
          forwardTo = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          maxBodySize = cfg.maxBodySize;
        };

        impermanence.persistedDirectories = [
          "/var/lib/vaultwarden"
        ];
      };
    };
}
