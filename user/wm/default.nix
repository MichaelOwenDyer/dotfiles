{ config, lib, ... }:

{
	imports = [
		./gnome.nix
	];

	# Declare the option to choose the window manager
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.wm = lib.mkOption {
				type = enum [ "gnome" ];
				default = "gnome";
				description = "Window manager and desktop environment";
			};
		});
	};
}