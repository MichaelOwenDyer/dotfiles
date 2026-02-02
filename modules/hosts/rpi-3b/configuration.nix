{
  inputs,
  ...
}:
{
  # Raspberry Pi 3B configuration

  flake.modules.nixos.rpi-3b =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        default-settings
        rpi-3b-hardware
        michael-rpi-3b
        ssh
        distributed-build-client
        tailscale
        adguardhome
      ];

      networking.hostName = "rpi-3b";

      # Disable documentation to speed up build times
      documentation.man.generateCaches = false;

      # Use the extlinux boot loader
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      distributed-build.client = with inputs.self.lib.distributedBuild; {
        rootSshKey = clients.rpi-3b.rootSshKey;
        builders = [ builders.rustbucket ];
      };

      # Allow remote deployment from rustbucket
      users.users.root.openssh.authorizedKeys.keys = [
        inputs.self.lib.sshKeys."michael@rustbucket".pub
      ];

      services.adguardhome.settings.dns.bind_hosts = [ "192.168.0.253" ];

      networking = {
        networkmanager.enable = true;
        # defaultGateway = {
        #   interface = "enu1u1";
        #   address = "192.168.0.254";
        # };
        # nameservers = [
        #   "1.1.1.1"
        #   "8.8.8.8"
        # ];
        # interfaces.enu1u1 = {
        #   ipv4.addresses = [
        #     {
        #       address = "192.168.0.253";
        #       prefixLength = 24;
        #     }
        #   ];
        # };
      };

      system.stateVersion = "25.11";
    };
}
