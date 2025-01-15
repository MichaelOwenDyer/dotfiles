{ config, pkgs, ... }:

{
	config = {
		# Set flag so that other modules can see
		system.wifi.enable = true;
		# Enable network manager
		networking.networkmanager.enable = true;
		# Add user to network manager group on the system
		users.users.${config.username}.extraGroups = [ "networkmanager" ];
		# Add network manager applet to home packages
		home-manager.users.${config.username}.home.packages = with pkgs; [
			networkmanagerapplet
		];
	};
}