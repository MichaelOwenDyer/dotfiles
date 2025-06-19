# The root module of michael's home-manager configuration on host claptrap.

{
  pkgs,
  ...
}:

let wayland = true;

in {
  home.stateVersion = "24.11";

  imports = [
    ../common/wm/gnome.nix
    ../common/ai.nix
    ../common/ide/cursor.nix
    ../common/browser/chrome.nix
    (import ../common/home.nix { inherit wayland; })
    (import ../common/slack.nix { inherit wayland; })
    (import ../common/discord.nix { inherit wayland; })
  ];

  wayland.windowManager.hyprland.settings.bind = [
    ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 10"
    ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 10"
  ];
}
