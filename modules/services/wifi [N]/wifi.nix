{
  inputs,
  ...
}:
{
  # WiFi configuration with NetworkManager and iwd

  flake.modules.nixos.wifi = {
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
