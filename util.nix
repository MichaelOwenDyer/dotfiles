{
  mkSchemeAttrs,
  nix-wallpaper,
}:

{
  # This function uses nix-wallpaper and base16 (borrowed from stylix) to generate
  # a default NixOS wallpaper based on a base 16 scheme.
  generateDefaultWallpaper = base16Scheme:
    let
      palette = (mkSchemeAttrs base16Scheme).withHashtag;
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
}
