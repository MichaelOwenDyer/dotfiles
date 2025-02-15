{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Import the options and settings in the various system modules
  imports = [
    ./audio.nix
    ./gaming.nix
    ./wifi.nix
		./stylix.nix
  ];

  # Declare basic system options
  options = with lib.types; {
    hostPlatform = lib.mkOption {
      type = str;
      description = "The platform the system is running on";
    };
    machine = {
      isLaptop = lib.mkEnableOption "common laptop settings";
    };
    # TODO: Move to user configuration
    os = {
      wayland = lib.mkOption {
        type = bool;
        default = true;
        description = "Whether wayland is used on the system";
      };
    };
  };
}
