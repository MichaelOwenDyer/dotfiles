{
  config,
  lib,
  pkgs,
  nur,
  ...
}:

{
  imports = [
    nur.modules.nixos.default
  ];

  # Declare configuration options for Firefox under options.profiles.<name>.browser.firefox
  options = {
    profiles =
      with lib.types;
      lib.mkOption {
        type = attrsOf (submodule {
          options.browser.firefox = {
            enable = lib.mkEnableOption "Firefox";
						extensions = lib.mkOption {
							type = listOf package;
							default = [];
						};
          };
        });
      };
  };

  # Configure Firefox for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.browser.firefox;
      in
      lib.mkIf cfg.enable {
        # Set the proper session variables for wayland
        home.sessionVariables = lib.mkIf config.os.wayland {
          MOZ_ENABLE_WAYLAND = "1";
        };

        # Enable firefox
        programs.firefox = {
          enable = true;
          package = if config.os.wayland then pkgs.firefox-wayland else pkgs.firefox;

          # Set the language packs # TODO: Configure via options
          languagePacks = [
            "en-US"
            "de"
          ];

          profiles."${username}".extensions.packages = cfg.extensions;
        };
      }
    ) config.profiles;
  };
}
