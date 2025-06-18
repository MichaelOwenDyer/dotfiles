{
  ...
}:

let wayland = true;

in {
  home.stateVersion = "24.11";

  imports = [
    (imports ../common/home.nix {
      inherit wayland;
      hashedPassword = "$y$j9T$toiC/s1uug/kKiuVcZxRB.$GXHVFF1L1wyOfdDMk647N7YkUxbaSFwnc4aSMSVa.88";
    })
    ../common/wm/gnome.nix
    ../common/wm/hyprland.nix
  ];
}

