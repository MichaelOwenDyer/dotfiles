{
  pkgs,
  buildIdeWithPlugins,
  plugins ? [],
  ...
}:

{
  home.packages = [
    (buildIdeWithPlugins pkgs.jetbrains "idea-ultimate" plugins)
  ];
}