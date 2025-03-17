{
  config,
  lib,
  pkgs,
  util,
  stylix,
  nix-wallpaper,
  ...
}:

{
  options = with lib.types; util.mkProfileOption lib {
    stylix = lib.mkOption {
      type = attrs;
      default = {};
      description = "Options to pass directly to Stylix";
    };
  };

  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.stylix;
      in
      lib.mkIf cfg.enable or false {
        # Pass the stylix configuration directly from the profile
        # but use a generated image based on the theme if none was specified
        stylix = {
          base16Scheme = config.stylix.base16Scheme;
          image = util.generateDefaultWallpaper { inherit pkgs stylix nix-wallpaper; } config.stylix.base16Scheme;
        } // cfg;
      }
    ) config.profiles;
  };
}
