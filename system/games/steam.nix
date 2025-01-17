{ config, lib, pkgs, ... }:

{
	# Declare the option to enable or disable Steam
	options.games.steam.enable = lib.mkEnableOption "Steam";

	# Configure Steam if enabled
	config = lib.mkIf config.games.steam.enable {  
		hardware.steam-hardware.enable = true;
		programs.steam = {
			enable = true;
			remotePlay.openFirewall = false; # Set true to open ports in the firewall for Steam Remote Play
		};
	};
}