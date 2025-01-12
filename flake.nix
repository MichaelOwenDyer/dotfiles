{
  description = "Michael's flake";

  inputs = {
    # Unstable and stable nixpkgs channels
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Nix User Repository
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = inputs @ { nixpkgs, home-manager, nur, nixos-hardware, ... }: let 
    nixosSystems = {
      claptrap = import ./machines/claptrap { inherit inputs nixpkgs home-manager nur nixos-hardware; };
      rustbucket = import ./machines/rustbucket { inherit inputs nixpkgs home-manager nur nixos-hardware; };
    };
  in {
    nixosConfigurations = nixosSystems;
    homeConfigurations = nixpkgs.lib.mapAttrs (name: system: 
      system.config.home-manager.users.${system.config.username}.home
    ) nixosSystems;
  };
}
