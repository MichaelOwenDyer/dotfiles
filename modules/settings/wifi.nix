{
  ...
}:
{
  # WiFi with NetworkManager, iwd backend, and systemd-resolved

  flake.modules.nixos.wifi =
    { ... }:
    {
      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd"; # Faster and more reliable than wpa_supplicant
        dns = "systemd-resolved";
      };

      networking.wireless.iwd = {
        enable = true;
        settings = {
          IPv6.Enabled = true;
          Settings.AutoConnect = true;
          General = {
            EnableNetworkConfiguration = true; # Built-in DHCP client
            # AddressRandomization = "network"; # MAC randomization for privacy
          };
          Network.EnableIPv6 = true;
        };
      };

      # DNS with caching and DNSSEC
      services.resolved = {
        enable = true;
        settings.Resolve = {
          DNSSEC = "allow-downgrade";
          FallbackDNS = [
            "1.1.1.1"
            "8.8.8.8"
            "2606:4700:4700::1111"
            "2001:4860:4860::8888"
          ];
        };
      };

      impermanence.persistedDirectories = [
        "/etc/NetworkManager/system-connections" # Saved WiFi passwords
        "/var/lib/NetworkManager"
        "/var/lib/iwd"
      ];

      impermanence.ephemeralPaths = [
        "/etc/NetworkManager" # Generated config (system-connections persisted separately)
        "/etc/iwd"
        "/etc/resolv.conf"
        "/etc/resolv.conf.bak"
        "/etc/resolvconf.conf"
        "/etc/dnsmasq-resolv.conf"
      ];
    };
}
