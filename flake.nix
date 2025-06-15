{
  description = "Michael's flake";

  outputs =
    inputs:
    let
      machines = {
        nixos = {
          claptrap = {
            system = "x86_64-linux";
            hostConfiguration = ./system/claptrap/configuration.nix;
            users.michael = ./user/michael/claptrap/home.nix;
          };
          rustbucket = {
            system = "x86_64-linux";
            hostConfiguration = ./system/rustbucket/configuration.nix;
            users.michael = ./user/michael/rustbucket/home.nix;
          };
        };
        darwin = {
          mac = {
            system = "x86_64-darwin";
            hostConfiguration = ./system/mac/configuration.nix;
            users.michael = ./user/michael/common/home.nix;
          };
        };
      };
      mkUtil = system: import ./util.nix {
        mkSchemeAttrs = (inputs.nixpkgs.legacyPackages.${system}.callPackage inputs.stylix.inputs.base16.lib {}).mkSchemeAttrs;
        nix-wallpaper = inputs.nix-wallpaper.packages.${system}.default;
      };
    in
    {
      nixosConfigurations = let lib = inputs.nixpkgs.lib; in lib.mapAttrs (
        hostName: { system, hostConfiguration, users }:
        lib.nixosSystem {
          # Define the system platform
          inherit system;
          # Allow the modules listed below to import any of these inputs
          # in addition to the default "pkgs", "lib", "config", and "options"
          specialArgs = {
            inherit users;
            inherit (inputs) hardware nur;
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
            zen-browser = inputs.zen-browser.packages.${system};
            util = mkUtil system;
          };
          modules = [
            hostConfiguration
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            {
              networking.hostName = hostName;
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays.nix inputs;
              };
              home-manager = {
                # By default, home manager wants to use a separate nixpkgs instance for each user, but this tells it to use the system nixpkgs
                useGlobalPkgs = true;
                # By default, home manager will install packages in /home/<username>/.nix-profile, but this puts them in /etc/profiles
                useUserPackages = true;
              };
            }
          ];
        }
      ) machines.nixos;

      darwinConfigurations = let lib = inputs.nix-darwin.lib; in lib.mapAttrs (
        hostName: { system, hostConfiguration, users }:
        lib.darwinSystem {
          # Define the system platform
          inherit system;
          # Allow the modules listed below to import any of these inputs
          # in addition to the default "pkgs", "lib", "config", and "options"
          specialArgs = {
            inherit users;
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
            util = mkUtil system;
          };
          modules = [
            hostConfiguration
            inputs.home-manager.darwinModules.home-manager
            {
              networking.hostName = hostName;
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays.nix inputs;
              };
              home-manager = {
                # By default, home manager wants to use a separate nixpkgs instance for each user, but this tells it to use the system nixpkgs
                useGlobalPkgs = true;
                # By default, home manager will install packages in /home/<username>/.nix-profile, but this puts them in /etc/profiles
                useUserPackages = true;
              };
            }
          ];
        }
      ) machines.darwin;

      homeConfigurations = let lib = inputs.nixpkgs.lib; in lib.listToAttrs (lib.flatten (
        lib.mapAttrsToList
        (
          hostname: { system, users, ... }:
          lib.mapAttrsToList (
            username: home:
            lib.nameValuePair
            "${username}@${hostname}"
            (inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = inputs.nixpkgs.legacyPackages.${system};
              modules = [ home ]; 
              extraSpecialArgs = {
                inherit (inputs) stylix nur;
                jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
                zen-browser = inputs.zen-browser.packages.${system};
                util = mkUtil system;
              };
            })
          ) users
        )
        {
          inherit (machines.nixos) claptrap rustbucket;
          inherit (machines.darwin) mac;
        }
      ));

      devShells = let
        supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        forEachSupportedSystem = f: inputs.nixpkgs.lib.genAttrs supportedSystems (system: f {
          pkgs = import inputs.nixpkgs { inherit system; };
        });
      in forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            home-manager
          ];
          NIX_CONFIG = "experimental-features = nix-command flakes";
        };
      });
    };

  inputs = {
    # Unstable nixpkgs (used by default)
    # https://github.com/NixOS/nixpkgs/tree/nixos-unstable
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Stable nixpkgs for the occasional fallback
    # https://github.com/NixOS/nixpkgs/tree/nixos-25.05
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    # Nix on macOS
    # https://github.com/LnL7/nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User home configuration
    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # agenix = {
    #   url = "github:ryantm/agenix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # Pre-built NixOS hardware configurations
    # https://github.com/NixOS/nixos-hardware
    hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # NUR (Nix User Repository) - community packages
    # https://github.com/nix-community/NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # List of systems for use in flake inputs
    # TODO: Include darwin in list
    # https://github.com/nix-systems/nix-systems
    systems = {
      url = "github:nix-systems/x86_64-linux";
    };

    # Theming for NixOS
    # https://github.com/danth/stylix
		# Themes: https://tinted-theming.github.io/tinted-gallery/
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        nur.follows = "nur";
      };
    };

    # Generate wallpapers for NixOS
    # https://github.com/lunik1/nix-wallpaper
    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # JetBrains IDE plugins (more up-to-date than nixpkgs)
    # https://github.com/theCapypara/nix-jetbrains-plugins
    # All plugins: https://raw.githubusercontent.com/theCapypara/nix-jetbrains-plugins/refs/heads/main/generated/all_plugins.json
    jetbrains-plugins = {
      url = "github:theCapypara/nix-jetbrains-plugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Zen Browser
    # https://github.com/MichaelOwenDyer/zen-browser-flake
    zen-browser = {
      url = "github:MichaelOwenDyer/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
