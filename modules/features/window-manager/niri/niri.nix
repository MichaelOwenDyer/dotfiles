{
  inputs,
  ...
}:
{
  # Niri scrolling window manager - NixOS module
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.nixos.niri-module ];

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable; # Use unstable version - breakages expected
        # package = pkgs.niri-stable;
      };

      # Use GTK portal as default for Wayland
      xdg.portal.config.common.default = [ "gtk" ];
    };

  # Niri scrolling window manager - Home Manager module
  # Composes input, appearance, and keybind configurations
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        niri-input
        niri-appearance
        niri-keybinds
      ];

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };

      # Cursor theme configuration
      # Ensures cursor changes based on context (text beam, pointer hand, etc.)
      home.pointerCursor = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 24;
        gtk.enable = true;
        x11.enable = true;
      };

      programs.niri.settings = {
        # Spawn commands at startup
        spawn-at-startup = [
          {
            # Export Wayland environment to D-Bus and systemd
            # Required for portals, gnome-keyring, and other session services
            argv = [
              "dbus-update-activation-environment"
              "--systemd"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP=niri"
              "XDG_SESSION_TYPE=wayland"
            ];
          }
          {
            # Initialize gnome-keyring secrets component
            # Connects PAM-started daemon to D-Bus session for apps like VSCode
            argv = [
              "gnome-keyring-daemon"
              "--start"
              "--components=secrets"
            ];
          }
        ];
      };
    };
}
