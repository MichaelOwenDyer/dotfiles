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
    ../modules/audio.nix
    ../modules/gnome.nix
    ../modules/gnome-keyring.nix
    (import ../modules/local-streaming-network.nix {
      wifiInterface = "wlan0";
      wifiDefaultGateway = "192.168.0.254";
      streamingInterface = "enp4s0";
      streamingIpv4Addr = "192.168.50.1";
      upstreamDnsServers = [ "8.8.8.8" "4.4.4.4" ];
    })
    ../modules/system-monitor.nix
    (import ../modules/plymouth.nix { theme = "colorful_sliced"; })
    ../modules/stylix.nix
  ];

  powerManagement.cpuFreqGovernor = "performance";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Optimize storage after each build
  nix.settings.auto-optimise-store = true;

  networking.interfaces.wlan0 = {
    ipv4.addresses = [{
      address = "192.168.0.1";
      prefixLength = 24;
    }];
  };
  
  # Passwordless sudo
  security.sudo.wheelNeedsPassword = false;

  stylix = {
    fonts.sizes = let fontSize = 11; in {
      applications = fontSize;
      desktop = fontSize;
      popups = fontSize;
      terminal = fontSize;
    };
  };
  qt.platformTheme = lib.mkForce "gnome";

  # Use Ly for the login screen
  services.displayManager.ly.enable = true;

  # Prevent GNOME from automatically suspending https://github.com/NixOS/nixpkgs/issues/100390
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(
        function(action, subject) {
          if (action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
              action.id == "org.freedesktop.login1.hibernate" ||
              action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
          {
              return polkit.Result.NO;
          }
        }
      );
    '';
  };

  programs.dconf.enable = true;

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

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = 15;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 7;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
  };
  
  system.stateVersion = "24.11";
}
