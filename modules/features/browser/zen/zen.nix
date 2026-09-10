{
  inputs,
  ...
}:
{
  # Zen Browser

  flake.modules.homeManager.zen-browser =
    { ... }:
    {
      imports = [
        inputs.zen-browser.homeModules.beta
      ];

      config = {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;
        };

        # Only one browser instance needed - it manages its own windows
        programs.niri.session-manager.singleInstanceApps = [ "zen" ];

        # Set Zen as default browser for web content
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "text/html" = "zen.desktop";
            "x-scheme-handler/http" = "zen.desktop";
            "x-scheme-handler/https" = "zen.desktop";
            "x-scheme-handler/about" = "zen.desktop";
            "x-scheme-handler/unknown" = "zen.desktop";
          };
        };
      };
    };
}
