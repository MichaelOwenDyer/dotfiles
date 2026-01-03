{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Generate wallpapers for NixOS
    nix-wallpaper = {
      url = "github:lunik1/nix-wallpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [
      (final: _prev: {
        nix-wallpaper = inputs.nix-wallpaper.packages.${final.stdenv.hostPlatform.system}.default;
      })
    ];
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = [
      (final: _prev: {
        nix-wallpaper = inputs.nix-wallpaper.packages.${final.stdenv.hostPlatform.system}.default;
      })
    ];
  };
}
