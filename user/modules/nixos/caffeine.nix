## Caffeine is a system tray service which prevents screen lock.

{
  config,
  lib,
  pkgs,
  util,
  ...
}:

{
  # Declare the option to enable caffeine under options.profiles.<name>.caffeine
  options = util.mkProfileOption lib {
    caffeine.enable = lib.mkEnableOption "Caffeine";
  };

  # Configure caffeine for each profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      lib.mkIf profile.caffeine.enable {
        # Enable the caffeine service
        services.caffeine.enable = true;
        # Add caffeine-ng to the user's home packages
        home.packages = with pkgs; [
          caffeine-ng
        ]
        ++ lib.optionals (config.services.xserver.desktopManager.gnome.enable) [
          # Gnome needs some extra packages for caffeine to show up in the system tray
          # TODO: Still not working
          gnomeExtensions.appindicator
          gnomeExtensions.caffeine
          gnomeExtensions.custom-osd
          libappindicator-gtk3
        ];
      }
    ) config.profiles;
  };
}
