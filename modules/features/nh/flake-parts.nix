{
  inputs,
  ...
}:
{
  # nh - Nix helper tool
  flake-file.inputs = {
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
