{
  lib,
  ...
} @ baseInputs:

let inputs = baseInputs // {
  wayland = true;
  hashedPassword = "$y$j9T$toiC/s1uug/kKiuVcZxRB.$GXHVFF1L1wyOfdDMk647N7YkUxbaSFwnc4aSMSVa.88";
};

in lib.mkMerge [
  { home.stateVersion = "24.11"; }
  (import ../common/home.nix inputs)
  (import ../common/wm/gnome.nix inputs)
  (import ../common/wm/hyprland.nix inputs)
]
