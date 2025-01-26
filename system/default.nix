{ config, lib, pkgs, ... }:

{
	# Import the options and settings in the various system modules
	imports = [
		./audio.nix
    ./gaming.nix
    ./wifi.nix
	];

  # Declare basic system options
	options = {
		machine = {
			isLaptop = lib.mkEnableOption "common laptop settings";
		};
		# TODO: Move to user configuration
		os = {
			wayland = lib.mkOption {
				type = lib.types.bool;
				description = "Whether wayland is used on the system";
				default = true;
			};
		};
	};
}
