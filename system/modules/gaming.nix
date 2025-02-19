{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Declare the option to enable or disable Steam
  options.games.steam.enable = lib.mkEnableOption "Steam";

  config =
    let
      cfg = config.games.steam;
    in
    lib.mkIf cfg.enable {
      # Configure Steam
      hardware.steam-hardware.enable = true;
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = false; # Set true to open ports in the firewall for Steam Remote Play
      };
      environment.systemPackages = with pkgs; [
        wine # For running Windows games on Linux
      ];
    };
}
