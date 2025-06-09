{
  pkgs,
  buildIdeWithPlugins,
  plugins ? [],
  ...
}:

{
  home.packages = [
    (buildIdeWithPlugins pkgs.jetbrains "rust-rover" plugins)
  ];
}