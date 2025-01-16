## All options for the entire configuration are defined here.

{ lib, ... }: let
  inherit (lib) mkOption mkEnableOption;
in with lib.types; {
  username = mkOption {
    type = str;
    description = "Primary user of the system";
  };

  fullName = mkOption {
    type = str;
    description = "Full name of the user";
  };

  email = mkOption {
    type = str;
    description = "Email address of the user";
  };
  
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

  development = {
    lang = {
      java = {
        enable = mkEnableOption "Java programming language support";
        mainVersion = mkOption {
          type = enum [ "8" "11" "17" ];
          description = "Main Java version to install. Will be used as JAVA_HOME.";
        };
        additionalVersions = mkOption {
          type = listOf (enum [ "8" "11" "17" ]);
          default = [ ];
          description = "Additional Java versions to install.";
        };
      };
      rust = {
        enable = mkEnableOption "Rust programming language support";
      };
    };
    ide = {
      vscode = {
        enable = mkEnableOption "Visual Studio Code IDE";
        # TODO
        # extraExtensions = mkOption {
        #   type = listOf str;
        #   default = [];
        #   description = "Extra extensions to install with Visual Studio Code";
        # };
      };
      rust-rover = {
        enable = mkEnableOption "RustRover IDE";
        extraPlugins = mkOption {
          type = listOf str;
          default = [];
          description = "Extra plugins to install with RustRover";
        };
      };
      intellij-idea = {
        enable = mkEnableOption "IntelliJ IDEA IDE";
        extraPlugins = mkOption {
          type = listOf str;
          default = [];
          description = "Extra plugins to install with IntelliJ IDEA";
        };
      };
    };
  };
}