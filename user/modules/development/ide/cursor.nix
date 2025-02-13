{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Declare configuration options for Cursor under options.profiles.<name>.development.ide.cursor
  options = {
    profiles =
      with lib.types;
      lib.mkOption {
        type = attrsOf (submodule {
          options.development.ide.cursor = {
            enable = lib.mkEnableOption "Cursor IDE";
          };
        });
      };
  };

  # Configure Cursor for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.development.ide.cursor;
      in
      lib.mkIf cfg.enable {
        home.packages = with pkgs; [ code-cursor ];
      }
    ) config.profiles;
  };
}
