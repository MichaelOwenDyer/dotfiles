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
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
            nix-wallpaper = inputs.nix-wallpaper.packages.${system};
            inherit (inputs) stylix hardware nur;
            util = import ./util.nix;
          };
          modules = [
            # pkgs configuration
            {
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays inputs;
              };
            }

            # System modules
            ./system/modules/nixos

            # Import Home Manager
            inputs.home-manager.nixosModules.home-manager
            # Import Stylix as a NixOS module (because home-manager is as well)
            inputs.stylix.nixosModules.stylix
            # User modules using Home Manager options
            ./user/modules/nixos

            # Machine configuration
            ./system/machines/nixos/${name}.nix
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
            jetbrains-plugins = inputs.jetbrains-plugins.lib.${system};
          };
          modules = [
            # pkgs configuration
            {
              nixpkgs = {
                hostPlatform = system;
                config.allowUnfree = true;
                overlays = import ./overlays inputs;
              };
            }

            # Use Home Manager as a Darwin module
            inputs.home-manager.darwinModules.home-manager
            # User modules
            ./user/modules/darwin

            # Machine configuration
            ./system/machines/darwin/${name}.nix
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

    # https://github.com/hercules-ci/gitignore.nix
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/edolstra/flake-compat
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # https://github.com/numtide/flake-utils
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # https://github.com/cachix/git-hooks.nix
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        gitignore.follows = "gitignore";
        flake-compat.follows = "flake-compat";
      };
    };

    # Theming for NixOS
    # https://github.com/danth/stylix
		# Themes: https://tinted-theming.github.io/tinted-gallery/
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        git-hooks.follows = "git-hooks";
      };
    };

    # Generate wallpapers for NixOS
    # https://github.com/lunik1/nix-wallpaper
    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        pre-commit-hooks.follows = "git-hooks";
      };
    };

    # JetBrains IDE plugins (more up-to-date than nixpkgs)
    # https://github.com/theCapypara/nix-jetbrains-plugins
    # All plugins: https://raw.githubusercontent.com/theCapypara/nix-jetbrains-plugins/refs/heads/main/generated/all_plugins.json
    jetbrains-plugins = {
      url = "github:theCapypara/nix-jetbrains-plugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-utils.follows = "flake-utils";
      };
    };
  };
}
