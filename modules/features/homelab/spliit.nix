{
  inputs,
  ...
}:
{
  # Spliit Cloud - Modernized fork of Spliit expense splitting app
  # https://github.com/antonio-ivanovski/spliit-cloud

  flake.modules.nixos.spliit =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.spliit;
      dbUrl = "postgresql://${cfg.database.user}@${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}";
    in
    {
      key = "spliit";

      imports = with inputs.self.modules.nixos; [
        cloudflare-tunnel
        podman
      ];

      options.spliit = {
        subdomain = lib.mkOption {
          type = lib.types.str;
          default = "spliit";
          description = "Subdomain for Spliit on Cloudflare Tunnel";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3003;
          description = "Internal web interface port for Spliit Cloud gateway";
        };

        apiPort = lib.mkOption {
          type = lib.types.port;
          default = 3001;
          description = "Internal API port for Spliit Cloud backend";
        };

        tag = lib.mkOption {
          type = lib.types.str;
          default = "latest";
          description = "Container image tag to use for Spliit Cloud services (e.g. 'v2.3.2' or 'latest')";
        };

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to environment file containing secrets for the backend API.
            Required variables: BETTER_AUTH_SECRET, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET
          '';
        };

        database = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "spliit";
            description = "PostgreSQL database name";
          };

          user = lib.mkOption {
            type = lib.types.str;
            default = "spliit";
            description = "PostgreSQL user name";
          };

          host = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "PostgreSQL host address";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 5432;
            description = "PostgreSQL port";
          };
        };
      };

      config = {
        services.postgresql = {
          enable = true;
          enableTCPIP = true;
          authentication = pkgs.lib.mkOverride 10 ''
            # type database DBuser origin-address auth-method
            local all all trust
            host all all 127.0.0.1/32 trust
            host all all ::1/128 trust
          '';
          ensureDatabases = [ cfg.database.name ];
          ensureUsers = [
            {
              name = cfg.database.user;
              ensureDBOwnership = true;
            }
          ];
        };

        virtualisation.oci-containers.backend = "podman";

        virtualisation.oci-containers.containers = {
          spliit-migrate = {
            image = "ghcr.io/antonio-ivanovski/spliit-cloud-migrate:${cfg.tag}";
            autoStart = true;
            extraOptions = [ "--network=host" ];
            environment = {
              DATABASE_URL = dbUrl;
              POSTGRES_PRISMA_URL = dbUrl;
              POSTGRES_URL_NON_POOLING = dbUrl;
            };
          };

          spliit-api = {
            image = "ghcr.io/antonio-ivanovski/spliit-cloud-api:${cfg.tag}";
            autoStart = true;
            extraOptions = [ "--network=host" ];
            environment = {
              PORT = toString cfg.apiPort;
              DATABASE_URL = dbUrl;
              POSTGRES_PRISMA_URL = dbUrl;
              POSTGRES_URL_NON_POOLING = dbUrl;
              APP_URL = config.cloudflare-tunnel.proxiedServices.spliit.url;
              BETTER_AUTH_URL = config.cloudflare-tunnel.proxiedServices.spliit.url;
              BETTER_AUTH_TRUSTED_ORIGINS = config.cloudflare-tunnel.proxiedServices.spliit.url;
              ENABLE_PASSKEY_AUTH = "false";
              ENABLE_EMAIL_AUTH = "false";
              SIGNUP_MODE = "invite_only";
            };
            environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          };

          spliit-worker = {
            image = "ghcr.io/antonio-ivanovski/spliit-cloud-worker:${cfg.tag}";
            autoStart = true;
            extraOptions = [ "--network=host" ];
            environment = {
              DATABASE_URL = dbUrl;
              APP_URL = config.cloudflare-tunnel.proxiedServices.spliit.url;
              JOBS_ADMIN_PORT = "3004";
              JOBS_ADMIN_HOST = "127.0.0.1";
              ENABLE_EMAIL_AUTH = "false";
            };
            environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
          };

          spliit-web = {
            image = "ghcr.io/antonio-ivanovski/spliit-cloud-web:${cfg.tag}";
            autoStart = true;
            dependsOn = [ "spliit-api" ];
            extraOptions = [
              "--network=host"
              "--add-host=api:127.0.0.1"
            ];
            entrypoint = "/bin/sh";
            cmd = [
              "-c"
              "sed -i 's/listen 80;/listen 127.0.0.1:${toString cfg.port};/' /etc/nginx/conf.d/default.conf && exec /docker-entrypoint.sh nginx -g 'daemon off;'"
            ];
            environment = {
              WEB_PORT = toString cfg.port;
              PORT = toString cfg.port;
              BIND_ADDRESS = "127.0.0.1";
              API_URL = "http://127.0.0.1:${toString cfg.apiPort}";
            };
          };
        };

        # Ensure systemd services run migrations before API and Worker start
        systemd.services.podman-spliit-api = {
          after = [ "podman-spliit-migrate.service" ];
          wants = [ "podman-spliit-migrate.service" ];
        };

        systemd.services.podman-spliit-worker = {
          after = [ "podman-spliit-migrate.service" ];
          wants = [ "podman-spliit-migrate.service" ];
        };

        cloudflare-tunnel.proxiedServices.spliit = {
          subdomain = cfg.subdomain;
          forwardTo = "http://127.0.0.1:${toString cfg.port}";
        };

        impermanence.persistedDirectories = [
          "/var/lib/postgresql"
        ];
      };
    };
}
