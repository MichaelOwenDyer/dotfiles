# Common configuration for Linux machines.

{
  hostname,
  users,
}:

{
  lib,
  pkgs,
  config,
  base16-lib,
  nix-wallpaper,
  ...
} @ inputs:

{
  imports = [
    ./modules/audio.nix
    ./modules/gnome-keyring.nix
    ./modules/gnome.nix
  ];

  networking.hostName = hostname;
  
  home-manager.users = users |> lib.mapAttrs (username: home: import home inputs);
  users.users = config.home-manager.users |> lib.mapAttrs (
    username: home:
    {
      isNormalUser = true;
      description = home.systemIntegration.description;
      hashedPassword = home.systemIntegration.hashedPassword;
      shell = home.systemIntegration.shell;
      extraGroups = [
        # TODO: need better system for assigning groups
        "wheel"
        "video"
        "audio"
        "input"
        "networkmanager"
      ];
    }
  );

  # Optimize storage after each build
  nix.settings.auto-optimise-store = true;
  # Run garbage collection weekly
  nix.gc.automatic = true;
  nix.gc.dates = "weekly";

  # Don't warn about building uncommitted git changes
  nix.extraOptions = ''
    warn-dirty = false
  '';

  programs.zsh.enable = true;
  programs.fish.enable = true;

  boot = {
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      timeout = lib.mkDefault 0; # Will still show previous generations if you press a key during startup
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
    image = let
      palette = (base16-lib.mkSchemeAttrs base16Scheme).withHashtag;
      out = nix-wallpaper.override {
        backgroundColor = palette.base01;
        logoColors = with palette; {
          color0 = base08;
          color1 = base09;
          color2 = base0A;
          color3 = base0B;
          color4 = base0D;
          color5 = base0E;
        };
      };
    in
    "${out}/share/wallpapers/nixos-wallpaper.png";
  };
}
