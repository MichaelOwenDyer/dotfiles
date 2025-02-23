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
      networking.networkmanager.enable = true;
    };
}
