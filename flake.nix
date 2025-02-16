{
  description = "Michael's flake";

  inputs = {
    # Unstable and stable nixpkgs channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
    };

    # Nix User Repository
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS hardware configuration
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # Nix JetBrains plugins
    nix-jetbrains-plugins = {
      url = "github:theCapypara/nix-jetbrains-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;
      machines = {
        claptrap = import ./system/machines/claptrap.nix inputs;
        rustbucket = import ./system/machines/rustbucket.nix inputs;
      };
    in
    {
      nixosConfigurations = machines;
      homeConfigurations = lib.listToAttrs (
        lib.flatten (
          lib.mapAttrsToList (
            host: machine:
            lib.mapAttrsToList (
              user: home: lib.nameValuePair "${user}@${host}" home
            ) machine.config.home-manager.users
          ) machines
        )
      );
    };
}
