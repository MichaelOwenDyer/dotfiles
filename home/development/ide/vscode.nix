{ config, lib, pkgs, ... }: let
	inherit (lib) mkDefault;
in {
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