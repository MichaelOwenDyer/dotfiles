{
  config,
  lib,
  util,
  ...
}:

{
  imports = [
    # Import Stylix for users to configure
    # stylix.homeManagerModules.stylix
  ];

  options = with lib.types; util.mkProfileOption lib {
    stylix = lib.mkOption {
      type = attrs;
      default = {
        enable = false;
      };
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
