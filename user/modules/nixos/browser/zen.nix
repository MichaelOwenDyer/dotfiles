{
  config,
  lib,
  util,
  zen-browser,
  ...
}:

{

  # Declare configuration options for Zen browser under options.profiles.<name>.browser.zen
  options = with lib.types; util.mkProfileOption lib {
    browser.zen = {
      enable = lib.mkEnableOption "Zen browser";
      extensions = lib.mkOption {
        type = listOf package;
        default = [];
      };
    };
  };

  # Configure Zen for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.browser.zen;
      in
      lib.mkIf cfg.enable {
        # Add the Zen package
        home.packages = lib.trace "zen" [
          zen-browser.specific
        ];
      }
    ) config.profiles;
  };
}
