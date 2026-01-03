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
}
