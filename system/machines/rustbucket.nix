# Configuration for my gaming PC which I built in 2015. Dual-boots Windows 10 and NixOS.
#
# Specs:
#
# - Motherboard: MSI Z97A Gaming 7
# - CPU: Intel Core i7 4790K
# - RAM: 32 GB DDR3
# - GPU: Nvidia 1660 Ti
# - Storage: 1TB Samsung 970 Pro SSD, 2TB Western Digital HDD, various other tiny drives

{ config, pkgs, ... }:

{

  imports = [
    # Common machine configuration
    ./nixos_default.nix
    # Add michael as a user
    ../../user/profiles/michael/rustbucket
  ];

  networking.hostName = "rustbucket";
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";
  gaming.enable = true;
  gnome-keyring.enable = true;

  stylix = {
    fonts.sizes = let fontSize = 11; in {
      applications = fontSize;
      desktop = fontSize;
      popups = fontSize;
      terminal = fontSize;
    };
    targets.plymouth.enable = false;
  };

  boot.plymouth = rec {
    theme = "colorful_sliced";
    themePackages = [
      (pkgs.adi1090x-plymouth-themes.override {
        selected_themes = [ theme ];
      })
    ];
  };

  # Use the GNOME display manager for the login screen
  services.xserver.displayManager.gdm.enable = true;
  # Enable GNOME desktop manager
  services.xserver.desktopManager.gnome.enable = true;
  # Enable GNOME keyring
  services.gnome.gnome-keyring.enable = true;
  
  # services.displayManager.autoLogin.enable = true;
  # services.displayManager.autoLogin.user = "michael";
  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      UseDns = true;
    };
  };
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  # https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true; # Use open source drivers
    nvidiaSettings = true; # Nvidia settings menu
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  
  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

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