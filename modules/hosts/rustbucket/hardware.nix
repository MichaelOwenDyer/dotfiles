{
  inputs,
  ...
}:
{
  flake.modules.nixos.rustbucket =
    { pkgs, ... }:
    {
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      environment.systemPackages = with pkgs; [
        ntfs3g
      ];

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/130acd15-8d64-4c32-a670-bc954b945594";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/4595-D8A1";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
          "umask=0077"
        ];
      };

      fileSystems."/mnt/steam_libraries/hdd" = {
        device = "/dev/disk/by-uuid/7EAEA85CAEA80EA9";
        fsType = "ntfs-3g";
        options = [
          "defaults"
          "nofail"
          "uid=1000"
          "gid=100"
          "umask=002"
          "windows_names"
          "locale=en_US.UTF-8"
        ];
      };

      fileSystems."/mnt/steam_libraries/ssd1" = {
        device = "/dev/disk/by-uuid/FADAB218DAB1D15D";
        fsType = "ntfs-3g";
        options = [
          "defaults"
          "nofail"
          "uid=1000"
          "gid=100"
          "umask=002"
          "windows_names"
          "locale=en_US.UTF-8"
        ];
      };

      fileSystems."/mnt/steam_libraries/ssd2" = {
        device = "/dev/disk/by-uuid/F808E17108E12F76";
        fsType = "ntfs-3g";
        options = [
          "defaults"
          "nofail"
          "uid=1000"
          "gid=100"
          "umask=002"
          "windows_names"
          "locale=en_US.UTF-8"
        ];
      };

      swapDevices = [ ];

      hardware.enableAllFirmware = true;
      hardware.cpu.intel.updateMicrocode = true;
    };
}
