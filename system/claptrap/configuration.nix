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
    hardware.nixosModules.dell-xps-13-9360
    (import ../nixos_default.nix { inherit hostname users; })
    ./hardware-configuration.nix
    ../modules/wifi.nix
  ];
  
  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";

  # Use Ly for the login screen
  services.displayManager.ly.enable = true;
  programs.hyprland.enable = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  stylix = {
    fonts.sizes = let fontSize = 12; in {
      applications = fontSize;
      desktop = fontSize;
      popups = fontSize;
      terminal = fontSize + 2;
    };
    targets.plymouth.enable = false;
    targets.qt.platform = lib.mkForce "qtct"; # Get rid of the warning
  };

  qt.platformTheme = lib.mkForce "gnome";

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

  security.polkit.enable = true;
  programs.dconf.enable = true;
  services.dbus.implementation = "broker";

}
