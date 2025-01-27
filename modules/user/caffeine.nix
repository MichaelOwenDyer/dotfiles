## Caffeine is a system tray service which prevents screen lock.

{ config, lib, pkgs, ... }:

{
	# Declare the option to enable caffeine under options.profiles.<name>.caffeine
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.caffeine = {
				enable = lib.mkEnableOption "Caffeine";
			};
		});
	};

	# Configure caffeine for each profile
	config.home-manager.users = lib.mapAttrs (username: profile: (lib.mkIf profile.caffeine.enable {
		# Enable the caffeine service
		services.caffeine.enable = true;
		# Add caffeine-ng to the user's home packages
		home.packages = with pkgs; [
			caffeine-ng
		] ++ lib.optionals (profile.wm == "gnome") [
			# Gnome needs some extra packages for caffeine to show up in the system tray
			gnomeExtensions.appindicator
			gnomeExtensions.caffeine
			gnomeExtensions.custom-osd
			libappindicator-gtk3
		];
	})) config.profiles;
}