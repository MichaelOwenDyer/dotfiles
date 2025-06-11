# Configuration for my old Dell XPS 13 9360 laptop

{
  lib,
  pkgs,
  config,
  hardware,
  ...
} @ inputs:

{
  imports = [
    hardware.nixosModules.dell-xps-13-9360
    ./hardware-configuration.nix
    ../nixos_default.nix
    ../modules/wifi.nix
  ];
  
  home-manager.users.michael = import ../../user/michael/claptrap/home.nix inputs;

  networking.hostName = "claptrap";
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";

  # Use Ly for the login screen
  services.displayManager.ly.enable = true;

  stylix = {
    fonts.sizes = let fontSize = 12; in {
      applications = fontSize;
      desktop = fontSize;
      popups = fontSize;
      terminal = fontSize + 2;
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

}
