{
  ...
}:
{
  # Distributed build server module
  # Servers import this and configure their settings in their configuration.nix

  flake.modules.nixos.distributed-build-server =
    { lib, config, pkgs, ... }:
    let
      cfg = config.distributed-build.server;
    in
    {
      options.distributed-build.server = {
        sshUser = lib.mkOption {
          type = lib.types.str;
          default = "nixremote";
          description = ''
            The name of the user which clients log in as to perform remote builds.
          '';
        };
        authorizedClients = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "SSH public keys authorized to log in as distributed-build.server.sshUser";
        };
        signingKeyPath = lib.mkOption {
          type = lib.nullOr (lib.types.oneOf [ lib.types.path lib.types.str ]);
          default = null;
          description = ''
            Set this to make this build server also serve precompiled binaries from its own store.
            This requires the binaries to be cryptographically signed by the builder.
            Configure the path to that private key here.
            This will additionally configure all clients using this remote builder to use the builder as a binary cache (substituter).
            IMPORTANT: After changing this, run `nix store sign --all -k <signingKeyPath>` to retroactively sign build artifacts.
          '';
        };
      };

      config = {
        users.users.nixremote = {
          isSystemUser = true;
          group = cfg.sshUser;
          home = "/var/lib/${cfg.sshUser}";
          createHome = true;
          shell = "${pkgs.bash}/bin/bash";
          openssh.authorizedKeys.keys = cfg.authorizedClients;
        };

        users.groups.${cfg.sshUser} = { };
        nix = {
          settings.trusted-users = [ cfg.sshUser ];
          extraOptions = ''
            secret-key-files = ${cfg.signingKeyPath}
          '';
        };

        # Ensure SSH is enabled on the server
        services.openssh.enable = true;

        impermanence.persistedFiles = [
          (toString cfg.signingKeyPath) # Ensure signing key is persisted across boots
        ];
        impermanence.ephemeralPaths = [
          "/var/lib/${cfg.sshUser}" # Home is regenerated at every boot
        ];
      };
    };
}
