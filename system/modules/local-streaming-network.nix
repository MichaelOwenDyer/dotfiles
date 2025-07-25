{
  wifiInterface,
  wifiDefaultGateway,
  streamingInterface,
  streamingIpv4Addr,
  streamingIpv6Addr,
  upstreamDnsServers,
}:

{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    tcpdump # monitor and debug TCP activity on the network
    iperf3 # speed test
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking = {
    firewall.trustedInterfaces = [ streamingInterface ];
    defaultGateway = {
      interface = wifiInterface;
      address = wifiDefaultGateway;
    };
    interfaces.${streamingInterface} = {
      ipv4.addresses = [{
        address = streamingIpv4Addr;
        prefixLength = 24;
      }];
      ipv6.addresses = [{
        address = streamingIpv6Addr;
        prefixLength = 64;
      }];
    };
    nat = {
      enable = true;
      internalInterfaces = [ streamingInterface ]; # Traffic coming FROM the dedicated gaming network
      externalInterface = wifiInterface; # Traffic going OUT to the Internet
    };
  };

  # Offer DHCP and DNS on the streaming subnet
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = streamingInterface; # dnsmasq listens ONLY on the dedicated Ethernet interface
      dhcp-range = [
        "192.168.50.100,192.168.50.200,12h"
        "fdc9:1a4b:53e1:50::,ra-stateless,12h"
      ];
      # Set the gateway and DNS servers for clients on this network
      dhcp-option = [
        "option:router,${streamingIpv4Addr}" # Give clients this IP as their default gateway so that we can forward requests to the internet for them
        "option:dns-server,${streamingIpv4Addr}" # We also forward DNS requests
        "option6:dns-server,[fdc9:1a4b:53e1:50::1]"
      ];
      # Don't read /etc/resolv.conf, instead use 
      no-resolv = true;
      server = upstreamDnsServers;
    };
  };

  # dnsmasq service depends on the streaming interface and should wait for it
  systemd.services.dnsmasq = {
    requires = [ "sys-subsystem-net-devices-${streamingInterface}.device" ];
    after = [ "sys-subsystem-net-devices-${streamingInterface}.device" ];
    wantedBy = [ "network-online.target" ];
  };

  # Open-source game streaming
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
    capSysAdmin = true;
  };

  # Extend the user service that is already created by the sunshine module.
  systemd.user.services.sunshine.serviceConfig = {
    # This is the correct way to set environment variables for the user service.
    # It overrides any inherited environment.
    Environment = [
      # As you correctly identified from the GitHub issue, unsetting this
      # variable forces Sunshine to fall back to using X11/XWayland.
      "WAYLAND_DISPLAY="

      # While a user service often inherits DISPLAY, explicitly setting it
      # is more robust and prevents "Unable to open display" errors.
      "DISPLAY=:0"

      # This ensures NVIDIA Prime Render Offload is enabled for the Sunshine process.
      "__NV_PRIME_RENDER_OFFLOAD=1"
    ];
  };
}
