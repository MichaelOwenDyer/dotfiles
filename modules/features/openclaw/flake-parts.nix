{
  inputs,
  ...
}:
{
  # nix-openclaw - Declarative Openclaw packaging
  # https://github.com/openclaw/nix-openclaw

  flake-file.inputs = {
    nix-openclaw = {
      url = "github:openclaw/nix-openclaw";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  # Add openclaw packages to overlay
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      inputs.nix-openclaw.overlays.default
    ];
  };
}
