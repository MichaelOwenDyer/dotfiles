{ config, lib, ... }:

{
	# Declare option to enable wifi
	options.system.io.wifi.enable = lib.mkEnableOption "wifi";

	# Forward config definition to NetworkManager
	config = lib.mkIf config.system.io.wifi.enable {
		networking.networkmanager.enable = true;
	};
}