# Common configuration for Linux machines.

{
  config,
  lib,
  pkgs,
  util,
  stylix,
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
  # Run garbage collection weekly
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

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

  stylix = rec {
    enable = true;
    targets = {
      console.enable = false;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
    image = util.generateDefaultWallpaper { inherit pkgs stylix nix-wallpaper; } base16Scheme;
  };
}
