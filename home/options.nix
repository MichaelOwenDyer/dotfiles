## All user options for the entire configuration are defined here.
## TODO: Refactor these out into their corresponding files

{ lib, ... }: let
  inherit (lib) mkOption mkEnableOption;
in with lib.types; {
  profiles = mkOption {
    type = attrsOf (submodule {
      options = {
        fullName = mkOption {
          type = str;
          description = "Full name of the user";
        };
        email = mkOption {
          type = str;
          description = "Email address of the user";
        };
        hashedPassword = mkOption {
          type = str;
          description = "Hashed password of the user";
        };

        browser = {
          firefox.enable = mkEnableOption "Firefox";
        };

        chat = {
          slack.enable = mkEnableOption "Slack";
          discord.enable = mkEnableOption "Discord";
        };

        development = {
          git = {
            enable = mkEnableOption "Git support";
            name = mkOption {
              type = str;
              description = "Name to use with Git";
              # default = fullName; TODO: Figure out how to reference fullName
            };
            email = mkOption {
              type = str;
              description = "Email to use with Git";
              # default = email;
            };
            extraConfig = mkOption {
              type = attrs;
              default = { };
              description = "Extra Git configuration";
            };
          };
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
            jetbrains = {
              default-plugins = mkOption {
                type = listOf str;
                default = [];
                description = "Plugins to install by default in JetBrains IDEs";
              };
              rust-rover = {
                enable = mkEnableOption "RustRover IDE";
                plugins = mkOption {
                  type = listOf str;
                  default = [];
                  description = "Extra plugins to install with RustRover";
                };
              };
              intellij-idea = {
                enable = mkEnableOption "IntelliJ IDEA IDE";
                plugins = mkOption {
                  type = listOf str;
                  default = [];
                  description = "Extra plugins to install with IntelliJ IDEA";
                };
              };
            };
          };
          shell = {
            zsh = {
              enable = mkEnableOption "Zsh shell support";
              oh-my-zsh = {
                enable = mkEnableOption "Oh My Zsh support";
                plugins = mkOption {
                  type = listOf str;
                  default = [];
                  description = "List of Oh My Zsh plugins to install. See https://github.com/ohmyzsh/ohmyzsh/wiki/plugins for a list of plugins.";
                };
              };
            };
          };
        };
      };
    });
  };
}