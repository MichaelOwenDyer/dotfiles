# Common configuration for Linux machines.

{
  config,
  lib,
  pkgs,
  nix-wallpaper,
  ...
}:

{
  # Enable the nix command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Optimize storage after each build
  nix.settings.auto-optimise-store = true;

  # Don't warn about building uncommitted git changes
  nix.extraOptions = ''
    warn-dirty = false
  '';

  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    # Use systemd-boot
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 7;
      # Do not allow editing the kernel command-line before boot, which is a security risk (you could add init=/bin/sh and get a root shell)
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };
    # Quiet boot
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [ "quiet" "splash" ];
    # Add a boot animation
    plymouth.enable = true;
  };

  # Setting correct application settings if we're running wayland
  environment.sessionVariables = lib.mkIf config.os.wayland {
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
  };

  # List packages installed by default
  environment.systemPackages = with pkgs; [
    git # version control
    vim # text editor
    curl # download files
    wget # download files
    lshw # list hardware
    gnugrep # grep
    gparted # partition manager
  ];

  # OpenGL support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable the X11 windowing system (and implicitly Wayland).
  services.xserver.enable = true;

  # Use the GNOME display manager for the login screen
  services.xserver.displayManager.gdm.enable = true;
  # TODO: Remove this and configure desktop environments with user profile
  # Enable GNOME desktop manager
  services.xserver.desktopManager.gnome.enable = true;
  # Enable GNOME keyring
  services.gnome.gnome-keyring.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable printing via CUPS
  services.printing.enable = true;

  # Enable sound
  audio.enable = true;

  stylix =
    let
      theme = {
        slug = "google-dark-catppuccin-macchiato";
        name = "Google Dark Catppuccin Macchiato";
        author = "Michael Dyer";
        variant = "dark";
        palette = {
          base00 = "1d1f21"; #1d1f21
          base01 = "282a2e"; #282a2e
          base02 = "373b41"; #373b41
          base03 = "969896"; #969896
          base04 = "b4b7b4"; #b4b7b4
          base05 = "c5c8c6"; #c5c8c6
          base06 = "e0e0e0"; #e0e0e0
          base07 = "ffffff"; #ffffff
          base08 = "ed8796"; #ed8796
          base09 = "f5a97f"; #f5a97f
          base0A = "eed49f"; #eed49f
          base0B = "a6da95"; #a6da95
          base0C = "8bd5ca"; #8bd5ca
          base0D = "8aadf4"; #8aadf4
          base0E = "c6a0f6"; #c6a0f6
          base0F = "f0c6c6"; #f0c6c6
        };
      };
    in
    {
      enable = true;

      # Enable all targets except the boot screen
      autoEnable = true;
      targets.console.enable = false;

      # Create home-manager.users.<user>.stylix options
      homeManagerIntegration.autoImport = true;
      # Inherit system theme
      homeManagerIntegration.followSystem = true;

      base16Scheme = theme;
      image =
        let
          hexCodes = lib.mapAttrs (name: code: "#${code}") theme.palette;
          wallpaper = nix-wallpaper.default.override {
            backgroundColor = hexCodes.base01;
            logoColors = with hexCodes; {
              color0 = base08;
              color1 = base09;
              color2 = base0A;
              color3 = base0B;
              color4 = base0D;
              color5 = base0E;
            };
          };
        in
        "${wallpaper}/share/wallpapers/nixos-wallpaper.png";

      opacity = {
        terminal = 0.9;
        popups = 0.9;
      };
    };
}
