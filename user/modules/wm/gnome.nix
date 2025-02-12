{ config, lib, pkgs, ... }:

{
	# options.profiles = with lib.types; lib.mkOption {
	#   type = attrsOf (submodule {
	#     options.wm.gnome = {
	#       # TODO: Add gnome options
	#     };
	#   });
	# };

	config = {
		home-manager.users = lib.mapAttrs (username: profile: lib.mkIf (profile.wm == "gnome") {
			# Add GNOME packages
			home.packages = with pkgs; [
				gnome-session
				gnome-screenshot
			];

			# Enable GNOME
			xsession = {
				enable = true;
				windowManager.command = "gnome-session";
			};

			services.gnome-keyring = {
			# Enable GNOME keyring
				enable = true;
				# list of (one of "pkcs11", "secrets", "ssh")
				components = [];
			};
		}) config.profiles;
	};

}