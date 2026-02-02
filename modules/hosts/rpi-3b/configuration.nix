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
        inputs.self.lib.sshKeys."michael@rustbucket".pub
      ];

      services.adguardhome.settings.dns.bind_hosts = [
        inputs.self.lib.hosts.rpi-3b.networks.home.ipv4
      ];

      system.stateVersion = "25.11";
    };
}
