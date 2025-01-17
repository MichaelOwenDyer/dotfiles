{ config, lib, pkgs, ... }:

{
  # Declare configuration options for Firefox under options.profiles.<name>.browser.firefox
  options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
    type = attrsOf (submodule {
      options.browser.firefox = {
        enable = mkEnableOption "Firefox";
      };
    });
  };

  # Configure Firefox for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: {
		# Setting the proper session variables for wayland
		home.sessionVariables = lib.mkIf config.os.wayland {
			MOZ_ENABLE_WAYLAND = "1";
		};

		programs.firefox = {
			enable = profile.browser.firefox.enable;
			package = if config.os.wayland then pkgs.firefox-wayland else pkgs.firefox;

			# Set the language packs # TODO: Configure via options
			languagePacks = [ "en-US" "de" ];
			
			# Add ublock-origin # TODO: Configure via options
			profiles."${username}".extensions = with pkgs.nur.repos.rycee.firefox-addons; [
				ublock-origin
			];
		};
	}) config.profiles;
}