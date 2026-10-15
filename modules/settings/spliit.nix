{
  inputs,
  ...
}:
{
  # Spliit - Minimalist open-source expense splitting app
  # https://github.com/spliit-app/spliit

  flake.modules.nixos.spliit =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.spliit;
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
          description = "Subdomain for Spliit on Cloudflare Tunnel (e.g. 'spliit')";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3003;
          description = "Internal web interface port for Spliit";
        };

        image = lib.mkOption {
          type = lib.types.str;
          default = "ghcr.io/spliit-app/spliit:latest";
          description = "OCI image to use for Spliit";
        };

        environmentFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to environment file containing secrets (e.g. NEXTAUTH_SECRET)";
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
          ensureDatabases = [ "spliit" ];
          ensureUsers = [
            {
              name = "spliit";
              ensureDBOwnership = true;
            }
          ];
        };

        virtualisation.oci-containers.backend = "podman";
        virtualisation.oci-containers.containers.spliit = {
          image = cfg.image;
          autoStart = true;
          extraOptions = [ "--network=host" ];
          environment = {
            PORT = toString cfg.port;
            POSTGRES_PRISMA_URL = "postgresql://spliit@127.0.0.1:5432/spliit";
            POSTGRES_URL_NON_POOLING = "postgresql://spliit@127.0.0.1:5432/spliit";
            DATABASE_URL = "postgresql://spliit@127.0.0.1:5432/spliit";
            NEXTAUTH_URL = config.cloudflare-tunnel.proxiedServices.spliit.url;
            NEXT_PUBLIC_APP_URL = config.cloudflare-tunnel.proxiedServices.spliit.url;
          };
          environmentFiles = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
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
