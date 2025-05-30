{
  description = "Michael's flake";

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs.lib) mapAttrs listToAttrs flatten mapAttrsToList nameValuePair;
      nixosMachines = {
        claptrap = "x86_64-linux";
        rustbucket = "x86_64-linux";
      };
      darwinMachines = {
        macaroni = "x86_64-darwin";
      };
    in
    rec {
      nixosConfigurations = mapAttrs (
        name: system:
        inputs.nixpkgs.lib.nixosSystem {
          # Define the system platform
          inherit system;
          # Allow the modules listed below to import any of these inputs
          # in addition to the default "pkgs", "lib", "config", and "options"
          specialArgs = {
            inherit (inputs) home-manager stylix hardware nur;
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
            nix-wallpaper = inputs.nix-wallpaper.packages.${system};
            zen-browser = inputs.zen-browser.packages.${system};
            util = import ./util.nix;
          };
          modules = [
            # pkgs configuration
            {
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays.nix inputs;
              };
            }
            # Machine configuration
            ./system/machines/${name}.nix
          ];
        }
      ) nixosMachines;

      darwinConfigurations = mapAttrs (
        name: system:
        inputs.nix-darwin.lib.darwinSystem {
          # Define the system platform
          inherit system;
          # Allow the modules listed below to import any of these inputs
          # in addition to the default "pkgs", "lib", "config", and "options"
          specialArgs = {
            inherit (inputs) home-manager;
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
          };
          modules = [
            # pkgs configuration
            {
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays.nix inputs;
              };
            }
            # Machine configuration
            ./system/machines/${name}.nix
          ];
        }
      ) darwinMachines;

      # TODO: Investigate how to make home-manager independently rebuildable
      # TODO: Use stylix.homeManagerModules.stylix
      homeConfigurations = listToAttrs (flatten (
        mapAttrsToList (
          host: machine:
          mapAttrsToList (
            user: home:
            nameValuePair "${user}@${host}" home
          ) machine.config.home-manager.users
        ) nixosConfigurations
      ));
    };

  inputs = {
    # Unstable nixpkgs (used by default)
    # https://github.com/NixOS/nixpkgs/tree/nixos-unstable
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Stable nixpkgs for the occasional fallback
    # https://github.com/NixOS/nixpkgs/tree/nixos-24.11
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
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
