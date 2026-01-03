{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Nix build tool
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.nh.overlays.default ];
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = [ inputs.nh.overlays.default ];
  };
}
