{
  ...
}:
{
  # AdGuard Home - Network-wide ad/tracker blocking DNS server
  # https://github.com/AdguardTeam/AdGuardHome
  #
  # Pi-Hole replacement with DNS-over-HTTPS/TLS/QUIC support.
  #
  # After deploying, configure via web UI at http://<host>:3000
  # then migrate settings you like into services.adguardhome.settings
  #
  # Home network integration:
  # - Point your router's DNS to this machine's IP, or
  # - Enable AdGuard Home's DHCP (disable router's DHCP first)

  flake.modules.nixos.adguardhome =
    { lib, ... }:
    {
      services.adguardhome = {
        enable = true;
        openFirewall = true; # Opens web UI port (3000)
        allowDHCP = true; # Grants CAP_NET_RAW for DHCP server

        mutableSettings = true;

        settings = {
          dns = {
            bind_hosts = [ "192.168.0.253" ]; # Set this in host configuration

            # Required for immutable settings to work
            bootstrap_dns = [
              "1.1.1.1"
              "8.8.8.8"
            ];

            # Add your preferred settings here after evaluating in web UI, e.g.:
            # upstream_dns = [ "https://cloudflare-dns.com/dns-query" ];
            # enable_dnssec = true;
            # cache_size = 4194304;
          };

          # DHCP disabled - let router handle DHCP, point router's DNS to this server
          # Re-enable when running on dedicated hardware (rpi-3b)
          # dhcp = {
          #   enabled = true;
          #   interface_name = "wlan0";
          #   local_domain_name = "lan";
          #   dhcpv4 = {
          #     gateway_ip = "192.168.0.254";
          #     subnet_mask = "255.255.255.0";
          #     range_start = "192.168.0.100";
          #     range_end = "192.168.0.200";
          #     lease_duration = 86400; # 24 hours
          #   };
          # };
        };
      };

      # Open DNS ports (web UI port handled by openFirewall above)
      networking.firewall = {
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 ];
      };

      # Disable DynamicUser to work with impermanence bind mounts
      systemd.services.adguardhome.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "adguardhome";
        Group = "adguardhome";
      };

      users.users.adguardhome = {
        isSystemUser = true;
        group = "adguardhome";
        home = "/var/lib/AdGuardHome";
      };

      users.groups.adguardhome = { };

      # Persist config, filters, query logs, statistics, DHCP leases
      impermanence.persistedDirectories = [
        "/var/lib/AdGuardHome"
      ];
    };
}
