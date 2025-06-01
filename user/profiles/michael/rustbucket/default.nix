_:

{
  imports = [
    ../default.nix
    ../wm/gnome.nix
    ../wm/hyprland.nix
  ];

  config.profiles.michael = {
    development.ide.jetbrains = {
      plugins = [ "com.github.copilot" ];
      intellij-idea.enable = true;
      intellij-idea.plugins = [ "nix-idea" ];
      rust-rover.enable = true;
    };
  };
}
