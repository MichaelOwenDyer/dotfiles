## All options for the entire configuration are defined here.

{ lib, ... }: let
  inherit (lib) mkOption mkEnableOption;
in with lib.types; {
  
  stateVersion = mkOption {
    type = str;
    default = "24.11";
    description = "State version of nixos and home-manager";
  };

  # Constants
  #
  # Object of options that can be set throughout the configuration.
  # Meant for options that get set by any module once, and never again.
  # const = let 
  #   mkConst = const: (mkOption { default = const; });
  # in {
  #   # signingKey = mkConst "F17DDB98CC3C405C"; TODO
  # };

  system = {
    wifi = {
      enable = mkEnableOption "wifi";
    };
  };

  machine = {
    isLaptop = mkOption {
      type = bool;
      description = "Whether the machine is a laptop";
      default = false;
    };

    temperaturePath = mkOption {
      type = path;
      description = "Machine specific path to the core temp class";
      default = "/sys/class/hwmon/hwmon4/temp1_input";
    };
  };

  os = {
    wayland = mkOption {
      type = bool;
      default = true;
      description = "Whether wayland is used on the system";
    };
  };

}