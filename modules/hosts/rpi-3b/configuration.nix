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
        system-cli
      ];

      networking.hostName = "rpi-3b";

      console.font = "Lat2-Terminus16";

      # Use the extlinux boot loader
      boot.loader.grub.enable = false;
      boot.loader.generic-extlinux-compatible.enable = true;

      networking = {
        networkmanager.enable = true;
        defaultGateway = {
          interface = "enu1u1";
          address = "192.168.0.254";
        };
        nameservers = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        interfaces.enu1u1 = {
          ipv4.addresses = [
            {
              address = "192.168.0.253";
              prefixLength = 24;
            }
          ];
        };
      };

      system.stateVersion = "25.11";
    };
}
