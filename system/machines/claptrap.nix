# Configuration for my old Dell XPS 13 9360 laptop

{
  lib,
  pkgs,
  config,
  hardware,
  ...
}:

{

  imports = [
    hardware.nixosModules.dell-xps-13-9360
    ./nixos_default.nix
  ];

  networking.hostName = "claptrap";
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";
  wifi.enable = true;
  gnome-keyring.enable = true;
  system.isLaptop = true;

  # Use Ly for the login screen
  services.displayManager.ly.enable = true;

  stylix = {
    fonts.sizes = let fontSize = 14; in {
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

  # Set cpu governor to powersave
  powerManagement.cpuFreqGovernor = "powersave";

  # Hibernate when power button is short-pressed, power off when long-pressed
  services.logind.powerKey = "hibernate";
  services.logind.powerKeyLongPress = "poweroff";

  # Sleep when lid is closed
  services.logind.lidSwitch = "suspend-then-hibernate";
  # Sleep after 10 minutes of idle time
  services.logind.extraConfig = ''
    IdleAction=suspend-then-hibernate
    IdleActionSec=10min
  '';

  # Hibernate after 20 minutes of sleep
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20min
  '';

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad = {
    tapping = true;
    tappingButtonMap = "lrm";
    disableWhileTyping = true;
    clickMethod = "clickfinger";
  };
  services.xserver.synaptics.palmDetect = true;

  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.dbus.implementation = "broker";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  ## Hardware configuration

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
