
{ config, lib, pkgs, ... }:

{
	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# Locale
	i18n.defaultLocale = "en_US.UTF-8";

	nix = {
		# Enable the nix command and flakes
		settings.experimental-features = [ "nix-command" "flakes" ];

		# Optimize storage
		# You can also manually optimize the store via:
		#    nix-store --optimise
		# Refer to the following link for more details:
		# https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
		settings.auto-optimise-store = true;

		# Store optimization
		# optimise.automatic = true; TODO: Investigate difference to above

		# Don't warn about building uncommitted git changes
		extraOptions = ''
			warn-dirty = false
		'';

		# Automatic garbage collection
		# gc = {
		# 	automatic = true;
		# 	dates = "weekly";
		# 	options = "--delete-older-than 7d";
		# };
	};

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

	# Enable GNOME keyring TODO: Decide if this is necessary
	services.gnome.gnome-keyring.enable = true;

	# Register a user account on the system.
	users.users.${config.username} = {
		isNormalUser = true;
		description = config.fullName;
		hashedPassword = "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";
		extraGroups = [ "wheel" "video" "audio" "input" ];   
	};

	# Enable automatic login for the user.
	# services.displayManager.autoLogin.enable = true;
	# services.displayManager.autoLogin.user = config.username;

	# Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
	systemd.services."getty@tty1".enable = false;
	systemd.services."autovt@tty1".enable = false;

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};

	# Home manager settings
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.users.${config.username} = {

		# Let Home Manager install and manage itself.
		programs.home-manager.enable = true;

		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

		home = {
			# Set username
			username = config.username;

			# Set home directory
			homeDirectory = "/home/${config.username}";

			packages = with pkgs; [
				# Global home packages
			] ++ lib.optionals config.os.wayland [
				# Wayland specific packages
			];

			# Set state version for home-manager
			stateVersion = "${config.stateVersion}";
		};
	};

	# Set state version for system
	system.stateVersion = "${config.stateVersion}";
}

