{
  inputs,
  ...
}:
{
  # Streaming network gateway - dedicated low-latency subnet for game streaming

  flake.modules.nixos.local-streaming-network =
    { pkgs, lib, config, ... }:
    let
      cfg = config.streaming.gateway;
      net = inputs.self.lib.networks;
    in
    {
      options.streaming.gateway = {
        enable = lib.mkEnableOption "streaming network gateway";
        upstreamInterface = lib.mkOption {
          type = lib.types.str;
        };
        upstreamGateway = lib.mkOption {
          type = lib.types.str;
          default = net.home.gateway;
        };
        interface = lib.mkOption {
          type = lib.types.str;
        };
        ipv4Address = lib.mkOption {
          type = lib.types.str;
          default = net.streaming.gateway;
        };
        ipv6Address = lib.mkOption {
          type = lib.types.str;
          default = "${net.streaming.ipv6Prefix}::1";
        };
        dhcp.rangeStart = lib.mkOption {
          type = lib.types.str;
          default = net.streaming.dhcp.rangeStart;
        };
        dhcp.rangeEnd = lib.mkOption {
          type = lib.types.str;
          default = net.streaming.dhcp.rangeEnd;
        };
        dhcp.leaseTime = lib.mkOption {
          type = lib.types.str;
          default = net.streaming.dhcp.leaseTime;
        };
        upstreamDns = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = net.streaming.upstreamDns;
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = with pkgs; [ tcpdump iperf3 ];

        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv4.conf.all.forwarding" = true;
          "net.ipv6.conf.all.forwarding" = true;
        };

        networking = {
          firewall.trustedInterfaces = [ cfg.interface ];
          defaultGateway = { interface = cfg.upstreamInterface; address = cfg.upstreamGateway; };
          interfaces.${cfg.interface} = {
            ipv4.addresses = [{ address = cfg.ipv4Address; prefixLength = net.streaming.prefixLength; }];
            ipv6.addresses = [{ address = cfg.ipv6Address; prefixLength = 64; }];
          };
          nat = {
            enable = true;
            internalInterfaces = [ cfg.interface ];
            externalInterface = cfg.upstreamInterface;
          };
        };

        services.dnsmasq = {
          enable = true;
          settings = {
            interface = cfg.interface;
            bind-interfaces = true;
            dhcp-range = [
              "${cfg.dhcp.rangeStart},${cfg.dhcp.rangeEnd},${cfg.dhcp.leaseTime}"
              "${net.streaming.ipv6Prefix}::,ra-stateless,${cfg.dhcp.leaseTime}"
            ];
            dhcp-option = [
              "option:router,${cfg.ipv4Address}"
              "option:dns-server,${cfg.ipv4Address}"
              "option6:dns-server,[${cfg.ipv6Address}]"
            ];
            no-resolv = true;
            server = cfg.upstreamDns;
          };
        };

        systemd.services.dnsmasq = {
          requires = [ "sys-subsystem-net-devices-${cfg.interface}.device" ];
          after = [ "sys-subsystem-net-devices-${cfg.interface}.device" ];
          wantedBy = [ "network-online.target" ];
        };

        impermanence.ephemeralPaths = [ "/etc/dnsmasq-conf.conf" ];
      };
    };
}
