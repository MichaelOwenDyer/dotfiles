{
  inputs,
  ...
}:
{
  # GNOME desktop environment - multi-context aspect

  flake.modules.nixos.gnome =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [
        inputs.self.modules.homeManager.gnome
      ];

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
        gnome-weather
        gnome-contacts
        gnome-online-accounts
        gnome-photos
        gnome-tour
        simple-scan
        yelp
      ];

      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
        ];
        config.gnome = {
          default = [
            "gnome"
            "gtk"
          ];
        };
      };
    };

  flake.modules.homeManager.gnome = {
    # Home-manager specific GNOME configuration
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        enable-hot-corners = true;
      };
    };
  };
}
