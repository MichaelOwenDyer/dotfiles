{
  wifiInterface,
  wifiDefaultGateway,
  streamingInterface,
  streamingIpv4Addr,
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
      dhcp-range = "192.168.50.100,192.168.50.200,12h";
      # Set the gateway and DNS servers for clients on this network
      dhcp-option = [
        "option:router,${streamingIpv4Addr}"
        "option:dns-server,${streamingIpv4Addr}"
      ];
      # Don't read /etc/resolv.conf, instead use 
      no-resolv = true;
      server = upstreamDnsServers;
    };
  };

  # dnsmasq service depends on the streaming interface
  systemd.services.dnsmasq = {
    requires = [ "sys-subsystem-net-devices-${streamingInterface}.device" ];
    after = [ "sys-subsystem-net-devices-${streamingInterface}.device" ];
    wantedBy = [ "network-online.target" ];
  };

  # services.sunshine = {
  #   enable = true;
  #   autoStart = true;
  #   openFirewall = true;
  # };
}
