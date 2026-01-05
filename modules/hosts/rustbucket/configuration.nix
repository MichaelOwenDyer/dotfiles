{
  inputs,
  ...
}:
{
  # Gaming PC configuration (MSI Z97A Gaming 7, i7 4790K, 1660 Ti)

  flake.modules.nixos.rustbucket =
    { config, lib, pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        rustbucket-hardware
        system-desktop
        gaming
        wifi
        niri
        gnome-keyring
        plymouth
        stylix-config
        local-streaming-network
        essential-packages
        ssh
      ];

      networking.hostName = "rustbucket";

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
        ipv4.addresses = [
          {
            address = "192.168.0.1";
            prefixLength = 24;
          }
        ];
      };

      # Local streaming network configuration
      localStreaming = {
        enable = true;
        wifiInterface = "wlan0";
        wifiDefaultGateway = "192.168.0.254";
        streamingInterface = "enp4s0";
        streamingIpv4Addr = "192.168.50.1";
        streamingIpv6Addr = "fdc9:1a4b:53e1:50::1";
        upstreamDnsServers = [
          "8.8.8.8"
          "4.4.4.4"
        ];
      };

      # Passwordless sudo
      security.sudo.wheelNeedsPassword = false;

      stylix = {
        fonts.sizes =
          let
            fontSize = 11;
          in
          {
            applications = fontSize;
            desktop = fontSize;
            popups = fontSize;
            terminal = fontSize;
          };
      };
      qt.platformTheme = lib.mkForce "gnome";

      services.displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
      services.displayManager.autoLogin = {
        enable = true;
        user = "michael";
      };

      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@tty1".enable = false;

      # Prevent GNOME from automatically suspending
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

      # Enable CUDA hardware acceleration
      nixpkgs.config.cudaSupport = true;

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        open = true;
        nvidiaSettings = true;
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
    };
}
