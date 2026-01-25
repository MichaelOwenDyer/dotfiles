{
  ...
}:
{
  # Distributed build server module
  # Servers import this and configure their settings in their configuration.nix

  flake.modules.nixos.distributed-build-server =
    { lib, config, ... }:
    {
      options.distributed-build.server = {
        authorizedKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "SSH public keys authorized to connect as nixremote";
        };
        signingKeyPath = lib.mkOption {
          type = lib.types.path;
          default = null;
          description = ''
            Path to private key for signing builds.
            After changing this run nix store sign --all -k path/to/key to retroactively sign build artifacts.
          '';
        };
      };

      config = {
        users.users.nixremote = {
          isSystemUser = true;
          group = "nixremote";
          home = "/var/lib/nixremote";
          createHome = true;
          shell = "/run/current-system/sw/bin/bash";
          openssh.authorizedKeys.keys = config.distributed-build.server.authorizedKeys;
        };

        users.groups.nixremote = { };
        nix = {
          settings.trusted-users = [ "nixremote" ];
          extraOptions = ''
            secret-key-files = ${config.distributed-build.server.signingKeyPath}
          '';
        };

        # Ensure SSH is enabled on the server
        services.openssh.enable = true;

        # Impermanence: persist signing key, ignore empty build user home
        impermanence = lib.mkIf (config ? impermanence) {
          persistedFiles = [
            (toString config.distributed-build.server.signingKeyPath)
          ];
          ignoredPaths = [
            "/var/lib/nixremote" # Empty home for build user
          ];
        };
      };
    };
}
