{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Declare the option to enable or disable Steam
  options.gaming.enable = lib.mkEnableOption "Gaming";

  config =
    let
      cfg = config.gaming;
    in
    lib.mkIf cfg.enable {
      # Configure Steam
      programs.steam.enable = true;
      programs.steam.gamescopeSession.enable = true;
      # https://search.nixos.org/options?channel=unstable&show=programs.gamemode.enable
      programs.gamemode.enable = true;
      environment.systemPackages = with pkgs; [
        wineWowPackages.waylandFull # Wine runs Windows games on Linux - experimental native Wayland support
        # wineWowPackages.stable # Wine runs Windows games on Linux
        mangohud # In-game overlay
        lutris # Steam alternative
        heroic # Steam alternative
        bottles # Run Windows games directly
      ];
    };
}
