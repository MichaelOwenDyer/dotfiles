# The root module of michael's home-manager configuration on host claptrap.

{
  pkgs,
  ...
}:

let wayland = true;

in {
  home.stateVersion = "24.11";

  imports = [
    (import ../common/home.nix { inherit wayland; })
    (import ../common/slack.nix { inherit wayland; })
    (import ../common/discord.nix { inherit wayland; })
    (import ../common/wayland-environment-variables.nix { enable = wayland; })
    ../common/stylix.nix
    ../common/ide/vscode.nix
    ../common/browser/zen.nix
    ../common/wm/gnome.nix
    ../common/ai.nix
    ../common/ide/cursor.nix
    ../common/browser/chrome.nix
  ];
}
