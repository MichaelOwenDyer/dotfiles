{
  config,
  lib,
  stylix,
  ...
}:

{
  imports = [
    # Import Stylix for users to configure
    # stylix.homeManagerModules.stylix
  ];

  options = {
    profiles =
      with lib.types;
      lib.mkOption {
        type = attrsOf (submodule {
          options.stylix = lib.mkOption {
            type = attrs;
            default = {
              enable = false;
            };
          };
        });
      };
  };

  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      lib.mkIf profile.stylix.enable {
        # Pass the stylix configuration directly from the profile
        stylix = profile.stylix;
      }
    ) config.profiles;
  };
}
