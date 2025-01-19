{ config, lib, pkgs, ... }:

{
	# Import the options and settings in the various system modules
	imports = [
		./audio.nix
    ./printing.nix
    ./steam.nix
    ./wifi.nix
	];

  # Declare basic system options
	options = let inherit (lib) mkOption mkEnableOption; in with lib.types; {
		machine = {
			isLaptop = mkOption {
				type = bool;
				description = "Whether the machine is a laptop";
				default = false;
			};
		};
		# TODO: Move to user configuration
		os = {
			wayland = mkOption {
				type = bool;
				description = "Whether wayland is used on the system";
				default = true;
			};
		};
	};

	config = {
		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

		# Locale
		i18n.defaultLocale = "en_US.UTF-8";

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
		boot.loader.systemd-boot.configurationLimit = 10;
		
		# Use latest kernel
		boot.kernelPackages = pkgs.linuxPackages_latest;

		# Setting correct application settings if we're running wayland
		environment.sessionVariables = lib.mkIf config.os.wayland {
			NIXOS_OZONE_WL = "1";
			GTK_USE_PORTAL = "1";
		};

		# List packages installed in system profile. To search, run:
		# $ nix search wget
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

		# Enable the GNOME Desktop Environment (uses Wayland by default).
		services.xserver.displayManager.gdm.enable = true;
		services.xserver.desktopManager.gnome.enable = true;

		# Enable GNOME keyring
		services.gnome.gnome-keyring.enable = true;
		# TODO: Investigate issue with VSCode authentication keyring "no longer matches"
		# security.pam.services.gdm-password.enableGnomeKeyring = true;
		# environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

		# Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
		systemd.services."getty@tty1".enable = false;
		systemd.services."autovt@tty1".enable = false;

		# Configure keymap in X11
		services.xserver.xkb = {
			layout = "us";
			variant = "";
		};
	};

}
