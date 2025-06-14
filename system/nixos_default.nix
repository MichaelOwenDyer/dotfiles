# Common configuration for Linux machines.

{
  lib,
  pkgs,
  util,
  users,
  ...
} @ inputs:

{
  imports = [
    ./modules/audio.nix
    ./modules/gnome-keyring.nix
    ./modules/gnome.nix
  ];

  home-manager.users = lib.mapAttrs (username: home: import home inputs) users;

  # Enable the nix command and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
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

  users.users.michael = {
    isNormalUser = true;
    description = "Michael Dyer";
    hashedPassword = "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
    ];
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = lib.mkDefault 0;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = lib.mkDefault 7;
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
    git
    vim
    curl
    wget
    ripgrep
    gparted
    zip
    unzip
    tree
    openssh
    gnupg1
  ];

  # OpenGL support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable the X11 windowing system (and implicitly Wayland).
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable printing via CUPS
  services.printing.enable = true;

  stylix = rec {
    enable = true;
    targets = {
      console.enable = false;
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/equilibrium-dark.yaml";
    image = util.generateDefaultWallpaper base16Scheme;
  };
}
