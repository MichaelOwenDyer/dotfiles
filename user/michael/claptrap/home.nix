# The root module of michael's home-manager configuration on host claptrap.

{
  pkgs,
  lib,
  ...
} @ flakeInputs:

let
  inputs = flakeInputs // {
    wayland = true;
  };
in
lib.mkMerge [
  { home.stateVersion = "24.11"; }
  (import ../common/home.nix inputs)
  (import ../common/wm/gnome.nix inputs)
  (import ../common/wm/hyprland.nix inputs // {
    wayland.windowManager.hyprland.settings.bind = [
      ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10"
      ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10"
    ];
  })
  (import ../common/slack.nix inputs)
  (import ../common/discord.nix inputs)
]