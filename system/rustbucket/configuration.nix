# Configuration for my gaming PC which I built in 2015. Dual-boots Windows 10 and NixOS.
#
# Specs:
#
# - Motherboard: MSI Z97A Gaming 7
# - CPU: Intel Core i7 4790K
# - RAM: 32 GB DDR3
# - GPU: Nvidia 1660 Ti
# - Storage: 1TB Samsung 970 Pro SSD, 2TB Western Digital HDD, various other tiny drives

{
  hostname,
  users,
}:

{
  config,
  lib,
  pkgs,
  ...
}:

{

  imports = [
    (import ../nixos_default.nix { inherit hostname users; })
    ./hardware-configuration.nix
    ../modules/gaming.nix
    ../modules/wifi.nix
    ../modules/gnome.nix
    (import ../modules/local-streaming-network.nix {
      wifiInterface = "wlan0";
      wifiDefaultGateway = "192.168.0.1";
      streamingInterface = "enp4s0";
      streamingIpv4Addr = "192.168.50.1";
      upstreamDnsServers = [ "192.168.0.100" ];
    })
    ../modules/system-monitor.nix
  ];

  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";

  networking.interfaces.wlan0 = {
    ipv4.addresses = [{
      address = "192.168.0.2";
      prefixLength = 24;
    }];
  };

  stylix = {
    fonts.sizes = let fontSize = 11; in {
      applications = fontSize;
      desktop = fontSize;
      popups = fontSize;
      terminal = fontSize;
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

  # Use the GNOME display manager for the login screen
  services.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
  # Prevent GNOME from automatically suspending https://github.com/NixOS/nixpkgs/issues/100390
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

  services.displayManager.autoLogin = {
    enable = true;
    user = "michael";
  };
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

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
    openFirewall = true;
  };

  # Enable CUDA hardware acceleration by default in apps that support it
  nixpkgs.config.cudaSupport = true;

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
}
