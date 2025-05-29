{
  lib,
  ...
}:

{
  imports = [
    ../default.nix
  ];

  config.profiles.michael = {
    chat.discord.enable = true;
    chat.slack.enable = true;
  };
}
