# This module adds some utilities under config.lib for other modules to use.

{
  # This function creates an option in the form profiles.<username>.<option>,
  # e.g. an option which can be configured independently for each user profile.
  mkProfileOption =
    lib: option:
    {
      profiles = with lib.types; lib.mkOption {
        type = attrsOf (submodule {
          options = option;
        });
      };
    };

  # This function uses nix-wallpaper and base16 (borrowed from stylix) to generate
  # a default NixOS wallpaper based on a base 16 scheme.
  generateDefaultWallpaper =
    { pkgs, stylix, nix-wallpaper }: base16Scheme:
    let
      palette = ((pkgs.callPackage stylix.inputs.base16.lib {}).mkSchemeAttrs base16Scheme).withHashtag;
      out = nix-wallpaper.default.override {
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
