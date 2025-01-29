{ config, lib, pkgs, ... }: let
	inherit (lib) mkDefault;
in {
	# Declare configuration options for Visual Studio Code under options.profiles.<name>.development.ide.vscode
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.ide.vscode = {
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
		});
	};
  
  # TODO: Investigate issue with VSCode authentication keyring "no longer matches"
  # security.pam.services.gdm-password.enableGnomeKeyring = true;
  # environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

	# Configure Visual Studio Code for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: let vscodeConfig = profile.development.ide.vscode; in lib.mkIf vscodeConfig.enable {
		programs.vscode = {
			enable = true;
			enableUpdateCheck = mkDefault false;
			enableExtensionUpdateCheck = mkDefault false;
			mutableExtensionsDir = mkDefault false;
			extensions = vscodeConfig.extensions;
			userSettings = vscodeConfig.userSettings;
		};
	}) config.profiles;
}