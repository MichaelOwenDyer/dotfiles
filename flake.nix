{
  description = "Michael's flake";

  outputs =
    inputs:
    let
      filteredInputs = {
        inherit (inputs)
          nixpkgs
          nixpkgs-stable
          nix-darwin
          home-manager
          nixos-hardware
          nur
          stylix
          nix-wallpaper
          nix-jetbrains-plugins
          ;
      };
      lib = inputs.nixpkgs.lib;
      nixosConfigurations = {
        claptrap = import ./system/machines/claptrap.nix filteredInputs;
        rustbucket = import ./system/machines/rustbucket.nix filteredInputs;
      };
      darwinConfigurations = {
        mac = import ./system/machines/mac.nix filteredInputs;
      };
    in
    {
      inherit nixosConfigurations darwinConfigurations;
      homeConfigurations = lib.listToAttrs (
        lib.flatten (
          lib.mapAttrsToList (
            host: machine:
            lib.mapAttrsToList (
              user: home: lib.nameValuePair "${user}@${host}" home
            ) machine.config.home-manager.users
          ) nixosConfigurations
        )
      );
    };

  inputs = {
    # Unstable nixpkgs (used by default)
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Stable nixpkgs (used exceptionally)
    nixpkgs-stable = {
      url = "github:NixOS/nixpkgs/nixos-24.11";
    };

    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/nix-community/home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/NixOS/nixos-hardware
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # https://github.com/nix-community/NUR
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Only need x86_64-linux here
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

    # https://github.com/danth/stylix
		# https://tinted-theming.github.io/tinted-gallery/
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

    # https://github.com/lunik1/nix-wallpaper
    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        pre-commit-hooks.follows = "git-hooks";
      };
    };

    # https://github.com/theCapypara/nix-jetbrains-plugins
    nix-jetbrains-plugins = {
      url = "github:theCapypara/nix-jetbrains-plugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-utils.follows = "flake-utils";
      };
    };
  };
}
