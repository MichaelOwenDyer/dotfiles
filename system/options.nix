## All options for the entire configuration are defined here.

{ lib, ... }: let
  inherit (lib) mkOption mkEnableOption types;
in {
  username = mkOption {
    type = types.str;
    description = "Primary user of the system";
  };

  fullName = mkOption {
    type = types.str;
    description = "Full name of the user";
  };

  email = mkOption {
    type = types.str;
    description = "Email address of the user";
  };
  
  stateVersion = mkOption {
    type = types.str;
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
      type = types.bool;
      description = "Whether the machine is a laptop";
      default = false;
    };

    temperaturePath = mkOption {
      type = types.path;
      description = "Machine specific path to the core temp class";
      default = "/sys/class/hwmon/hwmon4/temp1_input";
    };
  };

  os = {
    wayland = mkOption {
      type = types.bool;
      default = true;
      description = "Whether wayland is used on the system";
    };
  };

  development = {
    lang = {
      java = {
        enable = mkEnableOption "Java programming language support";
        mainVersion = mkOption {
          type = types.enum [ "8" "11" "17" ];
          description = "Main Java version to install. Will be used as JAVA_HOME.";
        };
        additionalVersions = mkOption {
          type = types.listOf (types.enum [ "8" "11" "17" ]);
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
        #   type = types.listOf types.str;
        #   default = [];
        #   description = "Extra extensions to install with Visual Studio Code";
        # };
      };
      rust-rover = {
        enable = mkEnableOption "RustRover IDE";
        extraPlugins = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Extra plugins to install with RustRover";
        };
      };
      intellij-idea = {
        enable = mkEnableOption "IntelliJ IDEA IDE";
        extraPlugins = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Extra plugins to install with IntelliJ IDEA";
        };
      };
    };
  };
}