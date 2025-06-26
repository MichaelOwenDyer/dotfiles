ides:

{
  lib,
  pkgs,
  jetbrains-plugins,
  ...
}:

{
  home.packages =
    lib.map
    (ide: jetbrains-plugins.buildIdeWithPlugins pkgs.jetbrains ide.name ide.plugins)
    ides;
}
