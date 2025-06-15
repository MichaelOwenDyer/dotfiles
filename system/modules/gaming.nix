{
  pkgs,
  ...
}:

{
  # Configure Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true; # Play games in a separate optimized session
  };
  hardware.xone.enable = true; # support for the xbox controller USB dongle
  # https://search.nixos.org/options?channel=unstable&show=programs.gamemode.enable
  programs.gamemode.enable = true;
  environment = {
    systemPackages = with pkgs; [
      wineWowPackages.waylandFull # Wine runs Windows games on Linux - experimental native Wayland support
      # wineWowPackages.stable # Wine runs Windows games on Linux
      mangohud # In-game overlay
      lutris # Steam alternative
      heroic # Steam alternative
      bottles # Run Windows games directly
      protonup # Manage Proton versions for Steam
    ];
    sessionVariables = {
      # Needed for Proton installation
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/compatibilitytools.d";
    };
  };
}
