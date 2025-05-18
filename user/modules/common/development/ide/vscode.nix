{
  config,
  lib,
  util,
  ...
}:

{
  # Declare configuration options for Visual Studio Code under options.profiles.<name>.development.ide.vscode
  options = with lib.types; util.mkProfileOption lib {
    development.ide.vscode = {
      enable = lib.mkEnableOption "Visual Studio Code IDE";
      extensions = lib.mkOption {
        type = listOf package;
        default = [];
        description = "Extensions to install with VSCode";
      };
      userSettings = lib.mkOption {
        type = attrs;
        default = {};
        description = "Custom user settings for VSCode";
      };
    };
  };

  # TODO: Investigate issue with VSCode authentication keyring "no longer matches"
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  # environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

  # Configure Visual Studio Code for each user profile
  # TODO: Use vscode-fhs package?
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.development.ide.vscode;
      in
      lib.mkIf cfg.enable {
        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles.default = {
            extensions = cfg.extensions;
            userSettings = cfg.userSettings;
            enableUpdateCheck = false;
            enableExtensionUpdateCheck = false;
          };
        };
      }
    ) config.profiles;
  };
}
