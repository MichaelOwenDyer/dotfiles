# Configuration for my gaming PC which I built in 2015. Dual-boots Windows 10 and NixOS.
#
# Specs:
#
# - Motherboard: MSI Z97A Gaming 7
# - CPU: Intel Core i7 4790K
# - RAM: 32 GB DDR3
# - GPU: Nvidia 1660 Ti
# - Storage: 1TB Samsung 970 Pro SSD, 2TB Western Digital HDD, various other tiny drives

{ config, ... }:

{

  imports = [
    # Common machine configuration
    ./default.nix
    # Add michael as a user
    ../../../user/profiles/michael/claptrap.nix
  ];
  
  networking.hostName = "rustbucket";
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";

  stylix = {
    cursor.size = 24;
    fonts.sizes = let fontSize = 11; in {
      applications = fontSize;
      desktop = fontSize;
      popups = fontSize;
      terminal = fontSize;
    };
  };

  # Enable automatic login for the user
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "michael";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Nvidia drivers for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Allow 15 seconds to choose OS in the bootloader
  boot.loader.timeout = 15;

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
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [];

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

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = false;

  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

}