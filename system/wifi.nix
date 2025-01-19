{ config, lib, ... }:

{
	# Declare option to enable wifi
	options.system.wifi.enable = lib.mkEnableOption "wifi";

	# Forward config definition to NetworkManager
	config = lib.mkIf config.system.wifi.enable {
		networking.networkmanager.enable = true;
	};
}