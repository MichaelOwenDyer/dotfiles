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
    };
}
