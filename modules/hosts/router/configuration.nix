{
  inputs,
  ...
}:
{
  # Single-arm router (managed switch, VLAN trunking)
  # Pure systemd-networkd stack (PPPoE -> DS-Lite ipip6)

  flake.modules.nixos.router =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      lanVlanId = 10;
      wanVlanId = 40;
      lanInterface = "lan";
      wanInterface = "wan";
      tunnelInterface = "ds-lite";
      tunnelRemote = "2001:a60:0:2::ffff";
      tunnelMtu = 1452; # Adjusted for PPPoE (1500 - 8 - 40)
      netHome = inputs.self.lib.networks.home;
      lanAddress = inputs.self.lib.hosts.router.networks.home.ipv4;
      lanPrefixLength = netHome.prefixLength;
    in
    {
      options.router = {
        trunkInterface = lib.mkOption {
          type = lib.types.str;
          description = "Physical interface used as VLAN trunk to the managed switch";
        };
        trustedInterfaces = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Extra interfaces to allow all inbound traffic on (e.g. WiFi, Tailscale)";
        };
      };

      imports = with inputs.self.modules.nixos; [
        default-settings
        adguardhome
        ssh
        ssh-client-hosts
      ];

      config = {
        services.logind.settings.Login = lib.mkForce {
          HandleLidSwitch = "ignore";
          HandleLidSwitchExternalPower = "ignore";
          HandleLidSwitchDocked = "ignore";
          IdleAction = "ignore";
        };

        systemd.targets = {
          sleep.enable = false;
          suspend.enable = false;
          hibernate.enable = false;
          hybrid-sleep.enable = false;
          suspend-then-hibernate.enable = false;
        };

        networking.networkmanager.enable = lib.mkForce false;
        networking.wireless.enable = lib.mkForce false;
        networking.wireless.iwd.enable = lib.mkForce false;
        networking.useDHCP = lib.mkForce false;

        boot.kernel.sysctl = {
          "net.ipv4.ip_forward" = 1;
          "net.ipv6.conf.all.forwarding" = true;
          "net.ipv4.ip_nonlocal_bind" = 1;
          "net.ipv4.conf.all.rp_filter" = 2;
          "net.ipv4.conf.default.rp_filter" = 2;
        };

        networking.useNetworkd = true;
        systemd.network = {
          enable = true;
          wait-online.enable = false;

          netdevs = {
            "20-${lanInterface}" = {
              netdevConfig = {
                Name = lanInterface;
                Kind = "vlan";
              };
              vlanConfig.Id = lanVlanId;
            };

            "20-${wanInterface}" = {
              netdevConfig = {
                Name = wanInterface;
                Kind = "vlan";
                MACAddress = "cc:ce:1e:ea:92:cd";
              };
              vlanConfig.Id = wanVlanId;
            };

            "40-${tunnelInterface}" = {
              netdevConfig = {
                Name = tunnelInterface;
                Kind = "ip6tnl";
                MTUBytes = toString tunnelMtu;
              };
              tunnelConfig = {
                Mode = "ipip6";
                Remote = tunnelRemote;
                # Prevent the DSTOPT extension header from being added
                EncapsulationLimit = "none";
              };
            };
          };

          networks = {
            "10-trunk" = {
              matchConfig.Name = config.router.trunkInterface;
              vlan = [
                lanInterface
                wanInterface
              ];
              networkConfig = {
                LinkLocalAddressing = "no";
                DHCP = "no";
                IPv6AcceptRA = false;
              };
            };

            "20-${lanInterface}" = {
              matchConfig.Name = lanInterface;
              address = [ "${lanAddress}/${toString lanPrefixLength}" ];
              networkConfig = {
                ConfigureWithoutCarrier = true;
                # Enable IPv6 routing and distribute the M-net prefix to the LAN
                IPv6SendRA = true;
                DHCPPrefixDelegation = true;
              };
            };

            "20-${wanInterface}" = {
              matchConfig.Name = wanInterface;
              networkConfig.LinkLocalAddressing = "no";
            };

            "30-ppp0" = {
              matchConfig.Name = "ppp0";
              networkConfig = {
                IPv6AcceptRA = true;
                DHCP = "ipv6";
                DHCPPrefixDelegation = true;
                Tunnel = tunnelInterface;
              };
              dhcpV6Config = {
                WithoutRA = "solicit";
                PrefixDelegationHint = "::/56";
              };
              ipv6AcceptRAConfig = {
                RouteMetric = 10;
              };
            };

            "40-${tunnelInterface}" = {
              matchConfig.Name = tunnelInterface;
              address = [ "192.0.0.2/29" ];
              routes = [
                {
                  Destination = "0.0.0.0/0";
                }
              ];
              linkConfig.MTUBytes = toString tunnelMtu;
            };
          };
        };

        services.pppd = {
          enable = true;
          peers.mnet = {
            autostart = true;
            enable = true;
            config = ''
              plugin pppoe.so
              ${wanInterface}
              user "X91104189@mdsl.mnet-online.de"
              password "xkw5T42G"
              +ipv6
              ipv6cp-use-ipaddr
              persist
              maxfail 0
              holdoff 5
              noipdefault
              defaultroute
            '';
          };
        };
        systemd.services.pppd-mnet =
          let
            wanDevice = [ "sys-subsystem-net-devices-${wanInterface}.device" ];
          in
          {
            bindsTo = wanDevice;
            after = wanDevice;
            wantedBy = lib.mkForce wanDevice;
          };

        systemd.services.ds-lite-dynamic-bind = {
          description = "Dynamically bind DS-Lite tunnel to ppp0 IPv6 address";
          after = [ "systemd-networkd.service" ];
          wantedBy = [ "multi-user.target" ];
          path = [
            pkgs.iproute2
            pkgs.gawk
            pkgs.gnugrep
          ];
          script = ''
            update_tunnel() {
              # Extract the live global IPv6 address from ppp0
              local ip=$(ip -6 addr show dev ppp0 scope global -tentative -deprecated | grep -w inet6 | awk '{print $2}' | cut -d/ -f1 | head -n1)
              if [ -n "$ip" ]; then
                echo "Binding ds-lite local address to $ip"
                ip -6 tunnel change ds-lite local "$ip"
              fi
            }

            # 1. Run once on startup to catch an already-established link
            update_tunnel

            # 2. Block and watch for any future IP changes (M-net prefix rotation)
            ip monitor address dev ppp0 | while read -r line; do
              update_tunnel
            done
          '';
          serviceConfig = {
            Restart = "always";
            RestartSec = "5s";
          };
        };

        networking.firewall.enable = false;
        networking.nftables.enable = true;

        networking.nftables.ruleset =
          let
            trustedRules =
              config.router.trustedInterfaces
              |> lib.concatMapStringsSep "\n        " (iface: "iifname \"${iface}\" accept");
          in
          ''
            table inet filter {
              chain input {
                type filter hook input priority filter; policy drop;

                iifname "lo" accept
                ${trustedRules}
                ct state established,related accept

                # ICMPv6 (RA, NS/NA, echo) — required for IPv6 operation
                ip6 nexthdr icmpv6 accept

                # Accept DHCPv6 replies from M-net
                iifname "ppp0" udp dport 546 accept comment "DHCPv6 client"

                # Accept incoming DS-Lite encapsulated IPv4 packets
                ip6 nexthdr 4 accept comment "Allow IPv4-in-IPv6 encapsulation"

                # ICMPv4 echo
                ip protocol icmp icmp type echo-request accept

                # LAN-facing services
                iifname "${lanInterface}" udp dport 67 accept comment "DHCP"
                iifname "${lanInterface}" tcp dport 53 accept comment "DNS/AdGuard"
                iifname "${lanInterface}" udp dport 53 accept comment "DNS/AdGuard"
                iifname "${lanInterface}" tcp dport 3000 accept comment "AdGuard web UI"
                iifname "${lanInterface}" tcp dport 22 accept comment "SSH"
              }

              chain forward {
                type filter hook forward priority filter; policy drop;

                meta nfproto ipv4 tcp flags syn / syn,ack tcp option maxseg size set ${toString (tunnelMtu - 20 - 20)}
                meta nfproto ipv6 tcp flags syn / syn,ack tcp option maxseg size set ${toString (tunnelMtu - 20)}

                ct state established,related accept

                # LAN -> tunnel (IPv4 internet)
                iifname "${lanInterface}" oifname "${tunnelInterface}" accept

                # LAN -> WAN (IPv6 internet)
                iifname "${lanInterface}" oifname "ppp0" accept
              }

              chain output {
                type filter hook output priority filter; policy accept;
              }
            }

            table ip nat {
              chain postrouting {
                type nat hook postrouting priority srcnat; policy accept;

                oifname "${tunnelInterface}" masquerade
              }
            }
          '';

        services.dnsmasq = {
          enable = true;
          settings = {
            port = 0;
            interface = lanInterface;
            bind-interfaces = true;
            dhcp-range = [ "${netHome.dhcp.rangeStart},${netHome.dhcp.rangeEnd},${netHome.dhcp.leaseTime}" ];
            dhcp-host =
              inputs.self.lib.hosts
              |> lib.mapAttrsToList (
                _name: host:
                let
                  homeNet = host.networks.home or null;
                in
                lib.optional (
                  homeNet != null && (homeNet.mac or null) != null && (homeNet.ipv4 or null) != null
                ) "${homeNet.mac},${homeNet.ipv4},${host.hostName}"
              )
              |> lib.concatLists;
            dhcp-option = [
              "3,${lanAddress}"
              "6,${lib.concatStringsSep "," netHome.dns}"
            ];
          };
        };
        systemd.services.dnsmasq =
          let
            lanDevice = [ "sys-subsystem-net-devices-${lanInterface}.device" ];
          in
          {
            bindsTo = lanDevice;
            after = lanDevice;
            wantedBy = lib.mkForce lanDevice;
          };

        services.adguardhome.settings.dns.bind_hosts = [ lanAddress ];

        environment.systemPackages = with pkgs; [ tcpdump ];
      };
    };
}
