{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./git.nix
    ./ide
    ./lang
  ];
}
