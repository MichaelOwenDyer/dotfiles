{ ... }:
{
  # Host and network registry
  # Reference: inputs.self.lib.hosts.<hostname>, inputs.self.lib.networks.<network>

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

  flake.lib.hosts = {
    rustbucket = {
      hostName = "rustbucket";
      system = "x86_64-linux";
      networks = {
        home = { ipv4 = "192.168.1.10"; interface = "wlan0"; mac = "e8:62:be:b9:c0:6c"; };
        streaming = { ipv4 = "192.168.50.1"; interface = "enp4s0"; isGateway = true; };
        tailscale = { ipv4 = "100.115.183.8"; ipv6 = "fd7a:115c:a1e0::c401:b77e"; };
      };
      build = {
        maxJobs = 8;
        speedFactor = 1;
        supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        signingKey = "rustbucket-1:AMe1QbSNHWw+Cyau5rwhAxknUDtmb49vY8tyIbOVAn0=";
      };
    };

    claptrap = {
      hostName = "claptrap";
      system = "x86_64-linux";
      networks = {
        home = { ipv4 = "192.168.1.11"; interface = "enp0s20f0u2"; mac = "00:e0:4c:0a:69:b6"; };
        tailscale = { ipv4 = "100.100.245.15"; ipv6 = "fd7a:115c:a1e0::f601:f51d"; };
      };
      build = {
        maxJobs = 4;
        speedFactor = 1;
        supportedSystems = [ "x86_64-linux" ];
        supportedFeatures = [ "nixos-test" "kvm" ];
        signingKey = null;
      };
    };

    mr3000x = {
      hostName = "mr3000x";
      system = null;
      networks = {
        home = { ipv4 = "192.168.1.2"; interface = null; mac = "08:8a:f1:05:ec:1c"; };
      };
    };

    switch = {
      hostName = "switch";
      system = null;
      networks = {
        home = { ipv4 = "192.168.1.3"; interface = null; mac = "cc:ba:bd:07:43:1d"; };
      };
    };

    mac = {
      hostName = "mac";
      tailscaleHostName = "jgfqqxm192";
      system = "aarch64-darwin";
      networks = {
        home = { ipv4 = "192.168.1.12"; interface = "en0"; mac = "80:a9:97:3c:54:8c"; };
        tailscale = { ipv4 = "100.111.69.23"; ipv6 = "fd7a:115c:a1e0::4d37:4517"; };
      };
      build = {
        maxJobs = 10;
        speedFactor = 2;
        supportedSystems = [ "aarch64-darwin" "x86_64-darwin" ];
        supportedFeatures = [ ];
        signingKey = null;
      };
    };

    phone = {
      hostName = "michaels-nothing-phone-4a";
      networks = {
        home = { ipv4 = "192.168.1.15"; interface = null; mac = "82:29:bc:59:7d:3b"; };
        tailscale = { ipv4 = "100.103.19.121"; ipv6 = "fd7a:115c:a1e0::ec01:138c"; };
      };
    };

    beste-s25 = {
      hostName = "bestes-s25";
      networks = {
        home = { ipv4 = "192.168.1.20"; interface = null; mac = "d6:13:66:c8:87:ba"; };
      };
    };

    idil-laptop = {
      hostName = "idils-laptop";
      networks = {
        home = { ipv4 = "192.168.1.21"; interface = null; mac = "7c:b5:66:b7:95:30"; };
      };
    };

    rpi-3b = {
      hostName = "rpi-3b";
      system = "aarch64-linux";
      networks = {
        home = { ipv4 = "192.168.1.253"; interface = "enu1u1"; mac = null; };
        tailscale = { ipv4 = "100.125.219.23"; ipv6 = "fd7a:115c:a1e0::2f37:db17"; };
      };
      build = {
        maxJobs = 4;
        speedFactor = 1;
        supportedSystems = [ "aarch64-linux" ];
        supportedFeatures = [ ];
        signingKey = null;
      };
    };

    router = {
      hostName = "router";
      system = "x86_64-linux";
      networks = {
        home = { ipv4 = "192.168.1.1"; interface = "lan"; mac = null; };
      };
    };
  };

  flake.lib.hostsLib = {
    getIpForNetwork = network: host:
      if host.networks.${network}.ipv4 != null then host.networks.${network}.ipv4
      else host.networks.tailscale.ipv4 or null;

    getTailscaleFqdn = host: tailnet:
      "${host.tailscaleHostName or host.hostName}.${tailnet.domain}";
  };
}
