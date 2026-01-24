{
  ...
}:
{
  # Stylix theme configuration (actual theme settings, not the tool itself)

  flake.modules.nixos.stylix-config =
    { pkgs, lib, ... }:
    let
      base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
      wallpaper = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
    in
    {
      stylix = {
        enable = true;
        inherit base16Scheme;
        image = wallpaper;
        targets.console.enable = false;
        targets.plymouth.enable = false;
        targets.qt.platform = lib.mkForce "qtct";
      };
    };

  flake.modules.homeManager.stylix-config =
    { pkgs, lib, ... }:
    let
      wallpaper = "${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png";
    in
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
        image = wallpaper;
      };
    };
}
