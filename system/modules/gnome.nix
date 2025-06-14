{
  lib,
  pkgs,
  ...
}:

{
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    epiphany # web browser
    geary # email client
    gnome-backgrounds
    gnome-calendar
    gnome-clocks
    gnome-font-viewer
    gnome-maps
    gnome-music
    gnome-themes-extra
    gnome-weather # weather application
    gnome-contacts # contact management application
    gnome-online-accounts
    gnome-photos # photo management application
    gnome-tour # GNOME Shell detects the .desktop file on startup, no need 
    simple-scan # document scanner
    yelp # help viewer

    # nautilus # file manager
    # adwaita-icon-theme # icon theme
    # baobab # disk analyzer
    # evince # document viewer
    # gnome-screenshot # screenshot tool
    # snapshot # camera application
    # totem # video player
    # loupe # image viewer
    # gnome-bluetooth # bluetooth manager
    # gnome-calculator # calculator application
    # gnome-characters # view and copy special characters
    # gnome-color-manager # color management in settings
    # gnome-control-center # settings application, don't disable
    # gnome-initial-setup
    # gnome-logs # log viewer
    # gnome-system-monitor # system monitor
    # glib # glib is a core library, don't disable
    # gnome-connections # remote desktop client
    # gnome-console # keep enabled as a fallback terminal
    # gnome-menus # used by GNOME Shell, don't disable
    # gnome-text-editor # notepad application
    # gnome-user-docs # useful reference to start with
    # orca # screen reader that keeps the desktop functional, only disable if needed
    # xdg-user-dirs # update user directories, don't disable unless you know what you're doing
  ];
}