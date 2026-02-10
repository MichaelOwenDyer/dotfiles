{
  inputs,
  ...
}:
{
  # Zen Browser

  flake.modules.homeManager.zen-browser =
    { pkgs, ... }:
    {
      # Only one browser instance needed - it manages its own windows
      programs.niri.session-manager.singleInstanceApps = [ "zen" ];

      home.packages = [ pkgs.zen-browser ];
    };
}
