{
  theme,
}:

{
  pkgs,
  ...
}:

{
  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" ];
    plymouth = {
      enable = true;
      inherit theme;
      # TODO: fix issue where this fails to build if a theme not in this package is selected
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override {
          selected_themes = [ theme ];
        })
      ];
    };
  };
}