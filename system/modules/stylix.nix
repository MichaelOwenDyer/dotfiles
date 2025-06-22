{
  lib,
  pkgs,
  nix-wallpaper,
  base16-lib,
  ...
}:

{
  stylix = rec {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
    image =
      let
        palette = (base16-lib.mkSchemeAttrs base16Scheme).withHashtag;
        out = nix-wallpaper.override {
          backgroundColor = palette.base01;
          logoColors = with palette; {
            color0 = base08;
            color1 = base09;
            color2 = base0A;
            color3 = base0B;
            color4 = base0D;
            color5 = base0E;
          };
        };
      in
      "${out}/share/wallpapers/nixos-wallpaper.png";
    targets.console.enable = false;
    targets.plymouth.enable = false;
    targets.qt.platform = lib.mkForce "qtct"; # Get rid of the warning
  };
}