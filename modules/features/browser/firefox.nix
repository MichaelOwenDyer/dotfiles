{
  ...
}:
{
  # Firefox browser

  flake.modules.homeManager.browser-firefox =
    { pkgs, config, ... }:
    {
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
