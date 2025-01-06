{
  description = "Michael's flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    systemSettings = {
      system = "x86_64-linux";
      hostname = "claptrap";
      timeZone = "Europe/Berlin";
      locale = "en_US.UTF-8";
    };
    userSettings = {
      username = "michael";
      name = "Michael Dyer";
      email = "michaelowendyer@gmail.com";
    };
  in {
    nixosConfigurations = {
      claptrap = nixpkgs.lib.nixosSystem {
        system = systemSettings.system;
        modules = [
          ./configuration.nix
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
    homeConfigurations = {
      michael = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${systemSettings.system};
        modules = [
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
    };
  };
}
