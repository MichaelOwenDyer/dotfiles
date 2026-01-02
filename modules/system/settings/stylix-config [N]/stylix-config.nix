{
  inputs,
  ...
}:
{
  # Stylix theme configuration (actual theme settings, not the tool itself)

  flake.modules.nixos.stylix-config =
    { pkgs, lib, ... }:
    let
      base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
      # We need to access base16-lib through the nix-wallpaper overlay
      palette = (lib.importJSON (
        pkgs.runCommand "base16-palette" { } ''
          ${pkgs.yq}/bin/yq -o=json '.' ${base16Scheme} > $out
        ''
      ));
    in
    {
      stylix = {
        enable = true;
        inherit base16Scheme;
        image = "${pkgs.nix-wallpaper}/share/wallpapers/nixos-wallpaper.png";
        targets.console.enable = false;
        targets.plymouth.enable = false;
        targets.qt.platform = lib.mkForce "qtct";
      };
    };

  flake.modules.homeManager.stylix-config =
    { pkgs, lib, ... }:
    {
      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
        image = "${pkgs.nix-wallpaper}/share/wallpapers/nixos-wallpaper.png";
      };
    };
}
