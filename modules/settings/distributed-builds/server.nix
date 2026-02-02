{ ... }:
{
  # Distributed build server

  flake.modules.nixos.distributed-build-server =
    { lib, config, pkgs, ... }:
    let
      cfg = config.distributed-build-server;
    in
    {
      options.distributed-build-server = {
        sshUser = lib.mkOption {
          type = lib.types.str;
          default = "nixremote";
        };
        authorizedClients = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
        signingKeyPath = lib.mkOption {
          type = lib.types.nullOr (lib.types.oneOf [ lib.types.path lib.types.str ]);
          default = null;
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
