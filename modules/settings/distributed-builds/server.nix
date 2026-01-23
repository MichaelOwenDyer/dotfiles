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
        nix.settings.trusted-users = [ "nixremote" ];

        # Ensure SSH is enabled on the server
        services.openssh.enable = true;
      };
    };
}
