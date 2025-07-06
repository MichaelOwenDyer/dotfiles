ides:

{
  lib,
  pkgs,
  ...
}:

{
  home.packages = lib.map (ide: pkgs.jetbrains.${ide}) ides;
}
