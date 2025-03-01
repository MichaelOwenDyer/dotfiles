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

  stylix = {
    enable = true;
    image =
      let
        wallpaper = nix-wallpaper.default.override {
          preset = "catppuccin-macchiato-rainbow";
        };
      in
      "${wallpaper}/share/wallpapers/nixos-wallpaper.png";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    polarity = "dark";

    autoEnable = true;
    targets.console.enable = false; # Don't theme bootloader

    homeManagerIntegration = {
      autoImport = true; # Create home-manager.users.<user>.stylix options
      followSystem = true; # Inherit system theme
    };

    opacity =
      let
        opacity = 0.95;
      in
      {
        terminal = opacity;
        popups = opacity;
      };

    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      monospace = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
