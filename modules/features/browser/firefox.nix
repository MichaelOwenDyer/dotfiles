{
  ...
}:
{
  # Firefox browser

  flake.modules.homeManager.browser-firefox =
    { pkgs, config, ... }:
    {
      # Only one browser instance needed - it manages its own windows
      programs.niri.session-manager.singleInstanceApps = [ "firefox" ];

      home.sessionVariables = {
        MOZ_ENABLE_WAYLAND = "1";
      };

      programs.firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
        languagePacks = [ "en-US" ];
        profiles."${config.home.username}".extensions.packages = [ ];
      };
    };
}
