{ config, lib, ... }:

{
  # Declare option to enable printing
  options.system.io.printing.enable = lib.mkEnableOption "printing";
  
  # Forward config definition to CUPS
	config = lib.mkIf config.system.io.printing.enable {
    services.printing.enable = true;
  };
}