inputs:

{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3bf7699c-c538-4368-842c-dce257ee819e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/281C-AB23";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
      "umask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/96ea764b-fd7b-4445-b437-ddb55c24ceed"; }
  ];

  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
}