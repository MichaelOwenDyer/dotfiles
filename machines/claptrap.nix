{ inputs, ... }:

with inputs;

nixpkgs.lib.nixosSystem {

  system = "x86_64-linux";

  modules = [

    ../. # Include top-level default.nix

    ../modules/development/ide/vscode.nix

    ../modules/browser/firefox.nix

    ../modules/shell/zsh.nix

    ## This module will return a `home-manager' object that can be used
    ## in other modules (including this one).
    home-manager.nixosModules.home-manager

    ## This module will return a `nur' object that can be used to access
    ## NUR packages.
    nur.nixosModules.nur

    # Use pre-defined hardware configuration for Dell XPS 13 9360
    nixos-hardware.nixosModules.dell-xps-13-9360

    ## System specific
    ##
    ## Closure that returns the module containing configuration specific to this machine
    ({ lib, config, pkgs, ... }: {

      networking.hostName = "claptrap";
      time.timeZone = "Europe/Berlin";

      # Set cpu governor to powersave
      powerManagement.cpuFreqGovernor = "powersave";

      # Sleep for 30 minutes then hibernate when lid is closed
      systemd.sleep.extraConfig = ''
          HibernateDelaySec=1800
      '';
      services.logind.lidSwitch = "suspend-then-hibernate";
      # Hibernate when power button is short-pressed, power off when long-pressed
      services.logind.powerKey = "hibernate";
      services.logind.powerKeyLongPress = "poweroff";
      # TODO: Test without this
      services.logind.extraConfig = ''
          HandlePowerKey=hibernate
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
      
      ## Setting keymap to `us' for this machine.
      os.keyboard.layout = "us";
      
      console = {
        font = "Lat2-Terminus16";
        keyMap = config.os.keyboard.layout;
      };

      users.users.${config.username} = {
        extraGroups = [ "wheel" "video" "input" ]; 
        isNormalUser = true;
      };

      ## Hardware configuration

      boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
          
      # Use the latest kernel
      boot.kernelPackages = (lib.mkDefault pkgs.linux_latest);

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/3bf7699c-c538-4368-842c-dce257ee819e";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/281C-AB23";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" "umask=0077" ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/96ea764b-fd7b-4445-b437-ddb55c24ceed"; }
      ];

      # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
      # (the default) this is the recommended approach. When using systemd-networkd it's
      # still possible to use this option, but it's recommended to use it in conjunction
      # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
      networking.useDHCP = lib.mkDefault true;
      # networking.interfaces.enp57s0u1u2.useDHCP = lib.mkDefault true;
      # networking.interfaces.wlp58s0.useDHCP = lib.mkDefault true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    })
  ];
}
