{
  enableGnomeIntegration ? false,
}:

{
  lib,
  pkgs,
  ...
}:

{
  # Enable the caffeine service
  services.caffeine.enable = true;
  # Add caffeine-ng to the user's home packages
  home.packages = with pkgs; [
    caffeine-ng
  ] ++ lib.optionals enableGnomeIntegration [
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.custom-osd
    libappindicator-gtk3
  ];
}