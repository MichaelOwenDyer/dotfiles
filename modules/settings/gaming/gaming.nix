{
  ...
}:
{
  # Gaming configuration

  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };

      programs.xwayland.enable = true; # Wayland compatibility layer

      hardware.xone.enable = true; # support for the xbox controller USB dongle

      programs.gamemode.enable = true;

      environment = {
        systemPackages = with pkgs; [
          wineWowPackages.waylandFull
          mangohud
          lutris
          heroic
          bottles
          protonup-ng
        ];
        sessionVariables = {
          # Use $HOME so this works for any user
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/compatibilitytools.d";
        };
      };

      impermanence.ephemeralPaths = [
        "/etc/gamemode.ini" # Gamemode config - generated
      ];
    };

  # Home Manager module for gaming - sets DISPLAY for Wayland graphical sessions
  flake.modules.homeManager.gaming =
    { ... }:
    {
      # Set DISPLAY for XWayland compatibility (Steam needs this in Wayland)
      systemd.user.sessionVariables = {
        DISPLAY = ":0";
      };
    };
}
