{
  description = "Michael's flake";

  outputs =
    inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = fn: inputs.nixpkgs.lib.genAttrs supportedSystems (system: fn {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      });
      userSystemIntegrationOptions = ./user/system-integration-options.nix;
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
          rpi-3b = {
            system = "aarch64-linux";
            hostConfiguration = ./system/rpi/configuration.nix;
            users.michael = ./user/michael/rpi/home.nix;
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
    in
    {
      nixosConfigurations = let lib = inputs.nixpkgs.lib; in lib.mapAttrs (
        hostname: { system, hostConfiguration, users }:
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            hardware = inputs.hardware.nixosModules;
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
            base16-lib = inputs.nixpkgs.legacyPackages.${system}.callPackage inputs.stylix.inputs.base16.lib {};
            nix-wallpaper = inputs.nix-wallpaper.packages.${system}.default;
          };
          modules = [
            userSystemIntegrationOptions
            (import hostConfiguration { inherit hostname users; })
            inputs.home-manager.nixosModules.home-manager
            inputs.stylix.nixosModules.stylix
            {
              nix.settings.experimental-features = [
                "flakes"
                "nix-command"
                "pipe-operators"
              ];
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays.nix inputs;
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        }
      ) machines.nixos;

      darwinConfigurations = let lib = inputs.nix-darwin.lib; in lib.mapAttrs (
        hostname: { system, hostConfiguration, users }:
        lib.darwinSystem {
          inherit system;
          specialArgs = {
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
            base16-lib = inputs.nixpkgs.legacyPackages.${system}.callPackage inputs.stylix.inputs.base16.lib {};
            nix-wallpaper = inputs.nix-wallpaper.packages.${system}.default;
          };
          modules = [
            userSystemIntegrationOptions
            (import hostConfiguration { inherit hostname users; })
            inputs.stylix.darwinModules.stylix # Declare no-op options for compatibility even though the theme won't be applied
            inputs.home-manager.darwinModules.home-manager
            {
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays.nix inputs;
              };
              home-manager = {
                useGlobalPkgs = true;
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
          lib.mapAttrsToList
          (
            username: home:
            lib.nameValuePair
            "${username}@${hostname}"
            (inputs.home-manager.lib.homeManagerConfiguration {
              pkgs = inputs.nixpkgs.legacyPackages.${system};
              modules = [
                home
                userSystemIntegrationOptions
                inputs.stylix.homeModules.stylix
                {
                  nixpkgs = {
                    config.allowUnfree = true;
                    overlays = import ./overlays.nix inputs;
                  };
                }
              ];
            })
          )
          users
        )
        {
          inherit (machines.nixos) claptrap rustbucket;
          inherit (machines.darwin) mac;
        }
      ));

      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          buildInputs = with pkgs; [
            git
            home-manager
          ];
          NIX_CONFIG = "experimental-features = flakes nix-command pipe-operators";
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
