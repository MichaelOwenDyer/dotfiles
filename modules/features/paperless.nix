{
  inputs,
  ...
}:
{
  # Paperless-ngx - Document management system
  # https://docs.paperless-ngx.com/

  flake.modules.nixos.paperless =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.paperless;
    in
    {
      key = "paperless";

      imports = with inputs.self.modules.nixos; [
        cloudflare-tunnel
      ];

      options.paperless = {
        subdomain = lib.mkOption {
          type = lib.types.str;
          default = "paperless";
          description = "Subdomain for Paperless-ngx on Cloudflare Tunnel (e.g. 'paperless')";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 28981;
          description = "Internal web interface port for Paperless-ngx";
        };

        address = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address to bind Paperless-ngx web UI to";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to file containing initial admin password";
        };

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to environment file containing secrets (e.g. PAPERLESS_SECRET_KEY)";
        };
      };

      config = {
        services.paperless = {
          enable = true;
          address = cfg.address;
          port = cfg.port;
          passwordFile = cfg.passwordFile;
          environmentFile = cfg.environmentFile;

          settings = {
            PAPERLESS_URL = config.cloudflare-tunnel.proxiedServices.paperless.url;
            PAPERLESS_TRUSTED_PROXIES = "127.0.0.1";
            PAPERLESS_ALLOWED_HOSTS = config.cloudflare-tunnel.proxiedServices.paperless.fqdn;
            PAPERLESS_USE_X_FORWARD_HOST = true;
            PAPERLESS_USE_X_FORWARD_PORT = true;
            PAPERLESS_OCR_LANGUAGE = "deu";
          };
        };

        cloudflare-tunnel.proxiedServices.paperless = {
          subdomain = cfg.subdomain;
          forwardTo = "http://${cfg.address}:${toString cfg.port}";
        };

        impermanence.persistedDirectories = [
          "/var/lib/paperless"
        ];
      };
    };
}
