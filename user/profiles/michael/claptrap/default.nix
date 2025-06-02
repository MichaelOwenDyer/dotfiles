{
  lib,
  ...
}:

{
  imports = [
    ../default.nix
    ../wm/gnome.nix
    ../wm/hyprland.nix
    ./hyprland-claptrap.nix
  ];

  config.profiles.michael = {
    chat.discord.enable = true;
    chat.slack.enable = true;
  };
}
