{
  pkgs,
  ...
}:

{
  imports = [
    ../common/wm/hyprland.nix
  ];

  wayland.windowManager.hyprland.settings.bind = [
    ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10"
    ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10"
  ];
}
