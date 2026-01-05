{
  inputs,
  ...
}:
{
  flake.modules.nixos.rpi-3b-hardware =
    { lib, modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.hardware.nixosModules.raspberry-pi-3
      ];

      boot.initrd.availableKernelModules = [ ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
        fsType = "ext4";
      };

      swapDevices = [
        {
          device = "/swapfile";
          size = 2048;
        }
      ];

      networking.useDHCP = lib.mkDefault true;
    };
}
