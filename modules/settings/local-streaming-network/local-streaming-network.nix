{
  ...
}:
{
  # Local network game streaming configuration
  # This is a complex feature that requires host-specific configuration
  # The actual network settings should be configured in the host feature

  flake.modules.nixos.local-streaming-network =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      # Define options for configurable parameters
      options.localStreaming = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true; # Importing the module enables it automatically, but it can be disabled without un-importing it
          description = "local streaming network";
        };
        wifiInterface = lib.mkOption {
          type = lib.types.str;
          description = "WiFi interface name";
        };
        wifiDefaultGateway = lib.mkOption {
          type = lib.types.str;
          description = "Default gateway IP for WiFi";
        };
        streamingInterface = lib.mkOption {
          type = lib.types.str;
          description = "Ethernet interface for streaming";
        };
        streamingIpv4Addr = lib.mkOption {
          type = lib.types.str;
          description = "IPv4 address for streaming interface";
        };
        streamingIpv6Addr = lib.mkOption {
          type = lib.types.str;
          description = "IPv6 address for streaming interface";
        };
        upstreamDnsServers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "8.8.8.8"
            "4.4.4.4"
          ];
          description = "Upstream DNS servers";
        };
      };

      config = lib.mkIf config.localStreaming.enable {
        environment.systemPackages = with pkgs; [
          tcpdump
          iperf3
        ];

        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv4.conf.all.forwarding" = true;
          "net.ipv6.conf.all.forwarding" = true;
        };

        networking = {
          firewall.trustedInterfaces = [ config.localStreaming.streamingInterface ];
          defaultGateway = {
            interface = config.localStreaming.wifiInterface;
            address = config.localStreaming.wifiDefaultGateway;
          };
          interfaces.${config.localStreaming.streamingInterface} = {
            ipv4.addresses = [
              {
                address = config.localStreaming.streamingIpv4Addr;
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = config.localStreaming.streamingIpv6Addr;
                prefixLength = 64;
              }
            ];
          };
          nat = {
            enable = true;
            internalInterfaces = [ config.localStreaming.streamingInterface ];
            externalInterface = config.localStreaming.wifiInterface;
          };
        };

        services.dnsmasq = {
          enable = true;
          settings = {
            interface = config.localStreaming.streamingInterface;
            bind-interfaces = true;
            dhcp-range = [
              "192.168.50.100,192.168.50.200,12h"
              "fdc9:1a4b:53e1:50::,ra-stateless,12h"
            ];
            dhcp-option = [
              "option:router,${config.localStreaming.streamingIpv4Addr}"
              "option:dns-server,${config.localStreaming.streamingIpv4Addr}"
              "option6:dns-server,[fdc9:1a4b:53e1:50::1]"
            ];
            no-resolv = true;
            server = config.localStreaming.upstreamDnsServers;
          };
        };

        systemd.services.dnsmasq = {
          requires = [ "sys-subsystem-net-devices-${config.localStreaming.streamingInterface}.device" ];
          after = [ "sys-subsystem-net-devices-${config.localStreaming.streamingInterface}.device" ];
          wantedBy = [ "network-online.target" ];
        };

        # Impermanence: dnsmasq state is ephemeral
        impermanence.ephemeralPaths = [
          "/etc/dnsmasq-conf.conf" # Generated config
        ];
      };
    };
}
