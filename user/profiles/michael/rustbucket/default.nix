_:

{
  imports = [
    ../default.nix
    ../wm/gnome.nix
    ../wm/hyprland.nix
  ];

  config.profiles.michael = {
    hashedPassword = "$y$j9T$toiC/s1uug/kKiuVcZxRB.$GXHVFF1L1wyOfdDMk647N7YkUxbaSFwnc4aSMSVa.88";
    development.ide.jetbrains = {
      plugins = [ "com.github.copilot" ];
      intellij-idea.enable = true;
      intellij-idea.plugins = [ "nix-idea" ];
      rust-rover.enable = true;
    };
  };
}
