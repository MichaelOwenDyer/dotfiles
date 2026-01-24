{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    zen-browser = {
      url = "github:MichaelOwenDyer/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      (final: _prev: {
        zen-browser = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.default;
      })
    ];
  };
}
