{ config, lib, ... }:

{
  # Declare option to enable wifi
  options.wifi.enable = lib.mkEnableOption "wifi";

  # Forward config definition to NetworkManager
  config =
    let
      cfg = config.wifi;
    in
    lib.mkIf cfg.enable {
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      networking.wireless.iwd = {
        enable = true;
        settings = {
          IPv6 = {
            Enabled = true;
          };
          Settings = {
            AutoConnect = true;
          };
        };
      };
    };
}
