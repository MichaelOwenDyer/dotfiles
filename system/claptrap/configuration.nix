# Configuration for my old Dell XPS 13 9360 laptop

{
  hostname,
  users,
}:

{
  lib,
  pkgs,
  hardware,
  ...
}:

{
  imports = [
    hardware.dell-xps-13-9360
    (import ../nixos_default.nix { inherit hostname users; })
    ./hardware-configuration.nix
    ../modules/wifi.nix
    ../modules/audio.nix
    ../modules/gnome.nix
    ../modules/gnome-keyring.nix
    (import ../modules/plymouth.nix { theme = "colorful_sliced"; })
    ../modules/stylix.nix
  ];

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Use Ly for the login screen
  services.displayManager.ly.enable = true;

  # Enable XDG desktop portal for Wayland
  xdg.portal = {
    enable = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs.zoom-us.enable = true;

  networking.wireless.scanOnLowSignal = false;

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  stylix = {
    fonts.sizes =
      let
        fontSize = 12;
      in
      {
        applications = fontSize;
        desktop = fontSize;
        popups = fontSize;
        terminal = fontSize + 2;
      };
  };
  qt.platformTheme = lib.mkForce "gnome";

  powerManagement.cpuFreqGovernor = "powersave";

  # Hibernate when power button is short-pressed, power off when long-pressed
  services.logind = {
    powerKey = "hibernate";
    powerKeyLongPress = "poweroff";
    # Sleep when lid is closed
    lidSwitch = "suspend-then-hibernate";
    # Sleep after 10 minutes of idle time
    extraConfig = ''
      IdleAction=suspend-then-hibernate
      IdleActionSec=10min
    '';
  };
  # Hibernate after 20 minutes of sleep
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=20min
  '';

  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      tappingButtonMap = "lrm";
      disableWhileTyping = true;
      clickMethod = "clickfinger";
    };
  };
  services.xserver.synaptics.palmDetect = true;

  programs.dconf.enable = true;
  security.polkit.enable = true;

  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = lib.mkDefault 0; # Will still show previous generations if you press a key during startup
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = lib.mkDefault 7;
      # Do not allow editing the kernel command-line before boot, which is a security risk (you could add init=/bin/sh and get a root shell)
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };

  system.stateVersion = "24.11";
}
