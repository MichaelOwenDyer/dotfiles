{
  inputs,
  ...
}:
{
  flake.modules.nixos.rustbucket-hardware =
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

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/cde2807c-cd90-4e03-97ef-2532813ddc6e";
        fsType = "btrfs";
        options = [ "subvol=@root" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/224D-B1B8";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/cde2807c-cd90-4e03-97ef-2532813ddc6e";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      fileSystems."/nix" = {
        device = "/dev/disk/by-uuid/cde2807c-cd90-4e03-97ef-2532813ddc6e";
        fsType = "btrfs";
        options = [ "subvol=@nix" ];
      };

      fileSystems."/var/log" = {
        device = "/dev/disk/by-uuid/cde2807c-cd90-4e03-97ef-2532813ddc6e";
        fsType = "btrfs";
        options = [ "subvol=@log" ];
      };

      fileSystems."/mnt/steam_libraries/hdd" = {
        device = "/dev/disk/by-uuid/7EAEA85CAEA80EA9";
        fsType = "ntfs3";
        options = [
          "rw"
          "exec"
          "prealloc"
          "nofail"
          "uid=1000"
          "gid=100"
          "umask=002"
          "windows_names"
        ];
      };

      fileSystems."/mnt/steam_libraries/ssd1" = {
        device = "/dev/disk/by-uuid/FADAB218DAB1D15D";
        fsType = "ntfs3";
        options = [
          "rw"
          "exec"
          "discard"
          "nofail"
          "prealloc"
          "uid=1000"
          "gid=100"
          "umask=002"
          "windows_names"
        ];
      };

      fileSystems."/mnt/windows" = {
        device = "/dev/disk/by-uuid/8EA61750A6173863";
        fsType = "ntfs3";
        options = [
          "ro"
          "nofail"
          "uid=1000"
          "gid=100"
          "umask=022"
          "windows_names"
          "iocharset=utf8"
        ];
      };

      swapDevices = [ ];

      hardware.enableAllFirmware = true;
      hardware.cpu.intel.updateMicrocode = true;
    };
}
