{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules = {
    nixos.overlays = {
      nixpkgs.overlays = [ inputs.nur.overlays.default ];
    };
    darwin.overlays = {
      nixpkgs.overlays = [ inputs.nur.overlays.default ];
    };
  };
}