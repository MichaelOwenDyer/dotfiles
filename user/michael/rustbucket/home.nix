{
  ...
}:

let wayland = true;

in {
  home.stateVersion = "24.11";

  imports = [
    (import ../common/home.nix {
      inherit wayland;
      hashedPassword = "$y$j9T$toiC/s1uug/kKiuVcZxRB.$GXHVFF1L1wyOfdDMk647N7YkUxbaSFwnc4aSMSVa.88";
    })
    (import ../common/wayland-environment-variables.nix { enable = wayland; })
    ../common/stylix.nix
    ../common/ide/vscode.nix
    ../common/ide/cursor.nix
    (import ../common/ide/jetbrains.nix (let plugins = [ "com.github.copilot" ]; in [
      { name = "idea-ultimate"; inherit plugins; }
      { name = "rust-rover"; inherit plugins; }
      { name = "webstorm"; inherit plugins; }
    ]))
    ../common/browser/zen.nix
    ../common/wm/gnome.nix
  ];
}

