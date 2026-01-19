{
  ...
}:
{
  # WiFi configuration with NetworkManager and iwd

  flake.modules.nixos.wifi = {
    networking.networkmanager = {
      enable = true;

      # iwd is faster, more reliable, and uses less memory than wpa_supplicant
      # Benefit: Quicker connections, better roaming, lower resource usage
      wifi.backend = "iwd";

      # Use systemd-resolved for DNS (integrates with NetworkManager)
      # Benefit: Proper per-interface DNS, DNSSEC support, better VPN handling
      dns = "systemd-resolved";
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
        General = {
          # Enable built-in DHCP client (faster than external dhclient)
          # Benefit: Faster IP acquisition, fewer processes
          EnableNetworkConfiguration = true;

          # Use randomized MAC address for scanning
          # Benefit: Privacy protection when probing for networks
          AddressRandomization = "network";
        };
        Network = {
          # Enable IPv6 privacy extensions
          # Benefit: Prevents tracking via stable IPv6 addresses
          EnableIPv6 = true;
        };
      };
    };

    # Enable systemd-resolved for modern DNS handling
    # Benefit: DNS caching, DNSSEC validation, split DNS for VPNs
    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      # Fallback DNS servers (Cloudflare + Google)
      fallbackDns = [
        "1.1.1.1"
        "8.8.8.8"
        "2606:4700:4700::1111"
        "2001:4860:4860::8888"
      ];
    };
  };
}
