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
        rootSshKey = inputs.self.lib.distributedBuild.clients.rpi-3b.rootSshKey;
        builders = with inputs.self.lib.distributedBuild.builders; [
          rustbucket-home
          rustbucket-tailscale
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [
        inputs.self.lib.keys.ssh.user."michael@rustbucket".pub
      ];

      services.adguardhome.settings.dns.bind_hosts = [
        inputs.self.lib.hosts.rpi-3b.networks.home.ipv4
      ];

      system.stateVersion = "25.11";
    };

  flake.lib.keys.ssh = {
    host.rpi-3b = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG69KLqwVXfDt4LF1E9v8tL8jlJbdqt+1MpT7J7M0i8r root@rpi-3b";
      path = "/etc/ssh/ssh_host_ed25519_key";
      persistPath = null; # no impermanence
    };
    root."root@rpi-3b" = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPQY1jga8pE59ErPEGTt5Rz0GjwGKJq8svjeWWnqeSc root@rpi-3b";
      privateKeySecret = "ssh-root-rpi-3b";
      deployPath = "/root/.ssh/nixremote";
      owner = "root";
    };
  };
}
