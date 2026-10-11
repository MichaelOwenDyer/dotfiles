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
        cloudflare-tunnel
      ];

      options.vaultwarden = {
        subdomain = lib.mkOption {
          type = lib.types.str;
          default = "vault";
          description = "Subdomain for Vaultwarden on Cloudflare Tunnel (e.g. 'vault')";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8222;
          description = "Internal Rocket server port for Vaultwarden";
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
            DOMAIN = config.cloudflare-tunnel.proxiedServices.vaultwarden.url;
            ENABLE_WEBSOCKET = true;
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = cfg.port;

            # Hardening
            SIGNUPS_ALLOWED = false;
            INVITATIONS_ALLOWED = false;
            SHOW_PASSWORD_HINT = false;

            # Proxy IP headers from Cloudflare Tunnel
            IP_HEADER = "CF-Connecting-IP";
            TRUSTED_PROXIES = builtins.toJSON [ "127.0.0.1" ];
          };
        };

        cloudflare-tunnel.proxiedServices.vaultwarden = {
          subdomain = cfg.subdomain;
          forwardTo = "http://127.0.0.1:${toString cfg.port}";
        };

        impermanence.persistedDirectories = [
          "/var/lib/vaultwarden"
        ];
      };
    };
}
