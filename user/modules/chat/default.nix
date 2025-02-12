{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./slack.nix
    ./discord.nix
  ];
}
