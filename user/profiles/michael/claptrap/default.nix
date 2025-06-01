{
  lib,
  ...
}:

{
  imports = [
    ../default.nix
    ../wm/gnome.nix
    ../wm/hyprland.nix
  ];

  config.profiles.michael = {
    chat.discord.enable = true;
    chat.slack.enable = true;
  };
}
