{ config, lib, pkgs, ... }: let
	# Choose the right package for the current window manager
	firefoxPkg = if config.os.wayland then pkgs.firefox-wayland else pkgs.firefox;
in {
	config.home-manager.users.${config.username} = {

		# Setting the proper session variables for wayland
		home.sessionVariables = lib.mkIf config.os.wayland {
			MOZ_ENABLE_WAYLAND = "1";
		};

		programs.firefox = {
			enable = true;
			package = firefoxPkg;

			# Set the language packs
			languagePacks = [ "en-US" "de" ];
			
			# Add ublock-origin
			profiles."${config.username}".extensions = with pkgs.nur.repos.rycee.firefox-addons; [
				ublock-origin
			];
		};
	};
}