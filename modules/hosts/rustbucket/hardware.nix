{
  ...
}:
{
  flake.modules.nixos.rustbucket-hardware =
    { ... }:
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

      # Persistent state for impermanence
      fileSystems."/persist" = {
        device = "/dev/disk/by-uuid/cde2807c-cd90-4e03-97ef-2532813ddc6e";
        fsType = "btrfs";
        options = [ "subvol=@persist" ];
        neededForBoot = true;
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
          "dmask=0002"
          "fmask=0002"
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

      # Windows boot entry for dual-boot
      boot.loader.systemd-boot.windows."10" = {
        title = "Windows 10";
        efiDeviceHandle = "HD1d65535a1";
      };

      # Redirect Steam compatdata from NTFS to btrfs
      # NTFS with windows_names can't create Proton's dosdevices symlinks (c:, d:)
      # Game files stay on NTFS (shared with Windows), prefixes live on btrfs
      systemd.tmpfiles.rules = [
        "d /home/michael/.local/share/Steam/steamapps/compatdata-ssd1 0755 michael users -"
        "L+ /mnt/steam_libraries/ssd1/SteamLibrary/steamapps/compatdata - - - - /home/michael/.local/share/Steam/steamapps/compatdata-ssd1"
        "d /home/michael/.local/share/Steam/steamapps/compatdata-hdd 0755 michael users -"
        "L+ /mnt/steam_libraries/hdd/SteamLibrary/steamapps/compatdata - - - - /home/michael/.local/share/Steam/steamapps/compatdata-hdd"
      ];

      hardware.enableAllFirmware = true;
      hardware.cpu.intel.updateMicrocode = true;
    };
}
