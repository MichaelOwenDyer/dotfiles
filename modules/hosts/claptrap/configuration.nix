{
  inputs,
  ...
}:
{
  # Dell XPS 13 9360 laptop configuration

  flake.modules.nixos.claptrap =
    { pkgs, lib, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        claptrap-hardware
        laptop
        ly
        niri
        dank-material-shell
        gnome-keyring
        plymouth
        ssh
        michael-claptrap
      ];

      networking.hostName = "claptrap";

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # Enable XDG desktop portal for Wayland
      xdg.portal = {
        enable = true;
        config = {
          common = {
            default = [ "gtk" ];
          };
        };
      };

      console.keyMap = "us";

      programs.zoom-us.enable = true;

      networking.wireless.scanOnLowSignal = false;

      virtualisation.podman = {
        enable = true;
        dockerSocket.enable = true;
      };

      # stylix = {
      #   fonts.sizes =
      #     let
      #       fontSize = 12;
      #     in
      #     {
      #       applications = fontSize;
      #       desktop = fontSize;
      #       popups = fontSize;
      #       terminal = fontSize + 2;
      #     };
      # };
      # qt.platformTheme = lib.mkForce "gnome";

      powerManagement.cpuFreqGovernor = "powersave";

      # Hibernate when power button is short-pressed, power off when long-pressed
      services.logind.settings.Login = {
        HandlePowerKey = "hibernate";
        HandlePowerKeyLongPress = "poweroff";
        HandleLidSwitch = "suspend-then-hibernate";
        IdleAction = "suspend-then-hibernate";
        IdleActionSec = "10min";
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
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
          timeout = lib.mkDefault 0;
          systemd-boot.enable = true;
          systemd-boot.configurationLimit = lib.mkDefault 7;
          systemd-boot.editor = false;
          efi.canTouchEfiVariables = true;
        };
      };

      system.stateVersion = "24.11";
    };
}
