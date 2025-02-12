## Common configuration for all machines.
## Since no options are declared here, every definition is implicitly inside "config".

{ config, lib, pkgs, ... }:

{
	# Configure the platform the system is running on
	nixpkgs.hostPlatform = config.hostPlatform;

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Enable the nix command and flakes
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Optimize storage after each build
	nix.settings.auto-optimise-store = true;
	# Optimize storage daily at 4am
	nix.optimise.automatic = true;
	nix.optimise.dates = [ "04:00" ];

	# Don't warn about building uncommitted git changes
	nix.extraOptions = ''
		warn-dirty = false
	'';

	# Bootloader
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Limit the number of generations to keep
	boot.loader.systemd-boot.configurationLimit = 7;
	
	# Do not allow editing the kernel command-line before boot, which is a security risk (you could add init=/bin/sh and get a root shell)
	boot.loader.systemd-boot.editor = false;

	# Use latest kernel
	boot.kernelPackages = pkgs.linuxPackages_latest;

	# Setting correct application settings if we're running wayland
	environment.sessionVariables = lib.mkIf config.os.wayland {
		NIXOS_OZONE_WL = "1";
		GTK_USE_PORTAL = "1";
	};

	# List packages installed by default
	environment.systemPackages = with pkgs; [
		git
		vim
		curl
		wget
		gnugrep
		gparted
	];

	# OpenGL support
	hardware.graphics.enable = true;

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
	system.audio.enable = true;
}
