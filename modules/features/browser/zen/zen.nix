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
        programs.niri.session-manager.singleInstanceApps = [ "zen" "zen-beta" ];

        # Set Zen as default browser for web content
        xdg.mimeApps = {
          enable = true;
          defaultApplications = let zen = "zen-beta.desktop"; in {
            "application/json" = zen;
            "text/html" = zen;
            "text/plain" = zen;
            "x-scheme-handler/http" = zen;
            "x-scheme-handler/https" = zen;
            "x-scheme-handler/about" = zen;
            "x-scheme-handler/mailto" = zen;
            "x-scheme-handler/unknown" = zen;
          };
        };
      };
    };
}
