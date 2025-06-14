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
  config,
  pkgs,
  ...
} @ inputs:

{

  imports = [
    ./hardware-configuration.nix
    ./nixos_default.nix
    ../modules/gaming.nix
  ];

  system.stateVersion = "24.11";
  time.timeZone = "Europe/Berlin";
  gaming.enable = true;

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
  services.displayManager.gdm.enable = true;
  
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
}