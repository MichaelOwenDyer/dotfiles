{
  inputs,
  ...
}:
{
  # Raspberry Pi 3B (AdGuard Home DNS server)

  flake.modules.nixos.rpi-3b =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        default-settings
        rpi-3b-hardware
        michael-rpi-3b
        ssh
        ssh-client-hosts
        distributed-build-client
        tailscale
        adguardhome
      ];

      networking.hostName = "rpi-3b";
      networking.networkmanager.enable = true;

      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      documentation.man.generateCaches = false;

      distributed-build-client = {
        rootSshKey = inputs.self.lib.hosts.rpi-3b.keys.root;
        builders = with inputs.self.lib.distributedBuild.builders; [
          rustbucket-home
          rustbucket-tailscale
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [
        inputs.self.lib.hosts.rustbucket.keys.users.michael.pub
      ];

      services.adguardhome.settings.dns.bind_hosts = [
        inputs.self.lib.hosts.rpi-3b.networks.home.ipv4
      ];

      system.stateVersion = "25.11";
    };

  flake.lib.hosts.rpi-3b = {
    hostName = "rpi-3b";
    system = "aarch64-linux";
    networks = {
      home = { ipv4 = "192.168.1.253"; interface = "enu1u1"; mac = null; };
      tailscale = { ipv4 = "100.125.219.23"; ipv6 = "fd7a:115c:a1e0::2f37:db17"; };
    };
    keys = {
      host = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG69KLqwVXfDt4LF1E9v8tL8jlJbdqt+1MpT7J7M0i8r root@rpi-3b";
        path = "/etc/ssh/ssh_host_ed25519_key";
      };
      root = {
        pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPQY1jga8pE59ErPEGTt5Rz0GjwGKJq8svjeWWnqeSc root@rpi-3b";
        privateKeySecret = "ssh-root-rpi-3b";
        deployPath = "/root/.ssh/nixremote";
        owner = "root";
      };
    };
  };
}
