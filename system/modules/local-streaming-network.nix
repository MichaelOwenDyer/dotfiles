{
  ...
}:

let
  wifiInterface = "wlan0";
  wifiDefaultGateway = "192.168.0.1";
  wifiIpv4Addr = "192.168.0.2";

  streamingInterface = "enp4s0";
  streamingSubnet = "192.168.50.0/24";
  streamingIpv4Addr = "192.168.50.1";
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking = {
    defaultGateway = {
      interface = wifiInterface;
      address = wifiDefaultGateway;
    };
    interfaces.${wifiInterface} = {
      ipv4.addresses = [{
        address = wifiIpv4Addr;
        prefixLength = 24;
      }];
      # TODO: add ipv6
    };
    interfaces.${streamingInterface} = {
      ipv4.addresses = [{
        address = streamingIpv4Addr;
        prefixLength = 24;
      }];
      # TODO: add ipv6
    };

    nat = {
      enable = true;
      internalInterfaces = [ streamingInterface ]; # Traffic coming FROM the dedicated gaming network
      externalInterface = wifiInterface; # Traffic going OUT to the Internet
      # Example port forwarding, adjust this
      # forwardPorts = [
      #   {
      #     sourcePort = 80;
      #     proto = "tcp";
      #     destination = "10.100.0.3:80";
      #   }
      # ];
    };
  };

  networking.firewall = {
    enable = true;
    # Explicitly allow forwarding for new connections from the dedicated network
    # and return traffic. This is important for the router functionality.
    extraCommands = ''
      nft add rule ip filter forward iifname ${streamingInterface} oifname ${wifiInterface} ct state new,related,established accept
      nft add rule ip filter forward iifname ${wifiInterface} oifname ${streamingInterface} ct state related,established accept
    '';
    # allowedUDPPorts = [ 27031 27032 27033 27034 27035 27036 ]; # Steam Remote Play UDP ports
    # allowedTCPPorts = [ 27036 27037 ]; # Steam Remote Play TCP ports
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      "listen-interface" = streamingInterface; # dnsmasq listens ONLY on the dedicated Ethernet interface

      # DHCP range for the TV and any other devices on the dedicated network
      "dhcp-range" = "${streamingSubnet},192.168.50.254,12h";
      # Note: dhcp-range should be a string, not a list of strings if it's a single range

      # Set the gateway and DNS servers for clients on this network
      "dhcp-option" = [
        "option:rostreaming}"
        "option:dns-server,8.8.8.8,8.8.4.4" # Google Public DNS, or use your main router's IP if you prefer
      ];
    };
  };
}
