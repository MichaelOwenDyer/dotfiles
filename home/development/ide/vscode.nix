{ config, lib, pkgs, ... }: let
	inherit (lib) mkDefault;
in {
  # Declare configuration options for Visual Studio Code under options.profiles.<name>.development.ide.vscode
  options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
    type = attrsOf (submodule {
      options.development.ide.vscode = {
        enable = mkEnableOption "Visual Studio Code IDE";
        extensions = mkOption {
          type = listOf package;
          default = [];
          description = "Extensions to install with VSCode";
        };
        userSettings = mkOption {
          type = attrs;
          default = {};
          description = "Custom user settings for VSCode";
        };
      };
    });
  };

  # Configure Visual Studio Code for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: let vscodeConfig = profile.development.ide.vscode; in {
		programs.vscode = {
			enable = vscodeConfig.enable;
			enableUpdateCheck = mkDefault false;
			enableExtensionUpdateCheck = mkDefault false;
			mutableExtensionsDir = mkDefault false;
			extensions = vscodeConfig.extensions;
			userSettings = vscodeConfig.userSettings;
		};
	}) config.profiles;
}