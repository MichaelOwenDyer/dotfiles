{
  lib,
  ...
}:

{
  imports = [
    ../common
  ];

  config.profiles.michael = {
    chat.discord.enable = true;
    chat.slack.enable = true;
  };
}
