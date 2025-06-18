# The root module of michael's home-manager configuration on host claptrap.

{
  pkgs,
  ...
}:

let wayland = true;

in {
  home.stateVersion = "24.11";

  imports = [
    (import ../common/home.nix { })
    ../common/wm/gnome.nix
    ../common/wm/hyprland.nix
    (import ../common/slack.nix { inherit wayland; })
    (import ../common/discord.nix { inherit wayland; })
    ../common/ai.nix
    ../common/ide/cursor.nix
    ../common/browser/chrome.nix
  ];

  wayland.windowManager.hyprland.settings.bind = [
    ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10"
    ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10"
  ];
}
