{ config, lib, ... }:

{
	# Declare option to enable printing
	options.system.printing.enable = lib.mkEnableOption "printing";
	
	# Forward config definition to CUPS
	config = lib.mkIf config.system.printing.enable {
		services.printing.enable = true;
	};
}