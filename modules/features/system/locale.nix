{
  ...
}:
{
  # Localization defaults (can be overridden per-host)

  flake.modules.nixos.locale =
    { lib, ... }:
    {
      i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
      time.timeZone = lib.mkDefault "Europe/Berlin";

      # Console font for HiDPI and standard displays
      console.font = lib.mkDefault "Lat2-Terminus16";

      impermanence.ephemeralPaths = [
        "/etc/locale.conf"
        "/etc/localtime"
        "/etc/zoneinfo"
      ];
    };
}
