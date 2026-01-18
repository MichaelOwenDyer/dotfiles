{
  inputs,
  ...
}:
{
  # Niri scrolling window manager - NixOS module
  # Note: programs.niri.settings is a home-manager option, not NixOS
  # The niri-flake module auto-imports homeModules.config when home-manager is detected
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.nixos.niri-module ];

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable; # Use unstable version - breakages expected
        # package = pkgs.niri-stable;
      };
    };

  # Niri scrolling window manager - Home Manager module
  # Composes input, appearance, and keybind configurations
  flake.modules.homeManager.niri =
    { ... }:
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

      programs.niri.settings = {
        # Spawn commands at startup
        spawn-at-startup = [
          {
            argv = [
              "dbus-update-activation-environment"
              "--systemd"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP=niri"
              "XDG_SESSION_TYPE=wayland"
            ];
          }
        ];
      };
    };
}
