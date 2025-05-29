{
  lib,
  util,
  ...
}:

{
  imports = [
    ./gnome.nix
    ./sway.nix
  ];

  options = with lib.types; util.mkProfileOption lib {
    windowManager = lib.mkOption {
      type = enum [ "gnome" "sway" ];
      default = "gnome";
      description = "Choose the window manager for the profile. Options are 'gnome' or 'sway'.";
    };
  };
}
