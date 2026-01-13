{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];
  };

  flake.modules.darwin.home-manager = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];
  };
}
