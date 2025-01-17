{ config, pkgs, ... }:

{
	# Enable network manager
	config.networking.networkmanager.enable = config.system.wifi.enable;
}