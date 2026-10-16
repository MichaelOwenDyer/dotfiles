{ ... }:
{
  flake.lib.networks = {
    home = {
      subnet = "192.168.1.0/24";
      gateway = "192.168.1.1";
      prefixLength = 24;
      dns = [ "192.168.1.1" ];
      dhcp = {
        rangeStart = "192.168.1.100";
        rangeEnd = "192.168.1.200";
        leaseTime = "24h";
      };
    };
    streaming = {
      subnet = "192.168.50.0/24";
      gateway = "192.168.50.1";
      prefixLength = 24;
      ipv6Prefix = "fdc9:1a4b:53e1:50";
      dhcp = {
        rangeStart = "192.168.50.100";
        rangeEnd = "192.168.50.200";
        leaseTime = "12h";
      };
      upstreamDns = [ "8.8.8.8" "8.8.4.4" ];
    };
    tailscale = {
      domain = "tail0fdbb0.ts.net";
      ipv4Prefix = "100";
      ipv6Prefix = "fd7a:115c:a1e0";
    };
  };

  flake.lib.tailnet = {
    domain = "tail0fdbb0.ts.net";
    ipv6Prefix = "fd7a:115c:a1e0";
  };
}