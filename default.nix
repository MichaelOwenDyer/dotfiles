
{ config, lib, pkgs, ... }:

{
  options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "michael";
      description = "Primary user of the system";
    };

    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Michael Dyer";
      description = "Full name of the user";
    };
    
    stateVersion = lib.mkOption {
      type = lib.types.str;
      default = "24.11";
      description = "State version of nixos and home-manager";
    };

    # Constants
    #
    # Object of options that can be set throughout the configuration.
    # Meant for options that get set by any module once, and never again.
    const = let 
      mkConst = const: (lib.mkOption { default = const; });
    in {
      # signingKey = mkConst "F17DDB98CC3C405C"; TODO
    };

    machine = {
      isLaptop = lib.mkOption {
        type = lib.types.bool;
        description = "Whether the machine is a laptop";
        default = false;
      };

      temperaturePath = lib.mkOption {
        type = lib.types.path;
        description = "Machine specific path to the core temp class";
        default = "/sys/class/hwmon/hwmon4/temp1_input";
      };
    };

    os = {
      wayland = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether wayland is used on the system";
      };
    };
  };

  # Global configuration
  #
  # Should only contain global settings that are not related to
  # any particular part of the system and could therefore be
  # extracted into their own module.
  config = {
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

		# OpenGL support
		hardware.opengl = {
			enable = true;
			driSupport = true;
			driSupport32Bit = true;
		};


		# Bootloader
		boot.loader.systemd-boot.enable = true;
		boot.loader.efi.canTouchEfiVariables = true;

		# Limit the number of generations to keep
		boot.loader.systemd-boot.configurationLimit = 10;

		# Locale
		i18n.defaultLocale = "en_US.UTF-8";

		# Allow unfree packages
		nixpkgs.config.allowUnfree = true;

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

		# Home manager settings
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;

		# Setting the `stateVersion' for both home-manager and system.
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
        # Setting state version for home-manager
        stateVersion = "${config.stateVersion}";
        # Global home packages
        packages = with pkgs; [

        ] ++ lib.optionals config.os.wayland [
          # Wayland specific packages
        ];
      };
    };

		# Setting state version for system
		system.stateVersion = "${config.stateVersion}";

		# TODO: Merge my configuration (below) with the above




		# Enable networking
		networking.networkmanager.enable = true;

		# Enable the X11 windowing system (and implicitly Wayland).
		services.xserver.enable = true;

		# Enable the GNOME Desktop Environment (uses Wayland by default).
		services.xserver.displayManager.gdm.enable = true;
		services.xserver.desktopManager.gnome.enable = true;

		# Define a user account.
		users.users.${config.username} = {
      isNormalUser = true;
      description = config.fullName;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    };

		# Enable automatic login for the user.
		services.displayManager.autoLogin.enable = true;
		services.displayManager.autoLogin.user = config.username;

		# Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
		systemd.services."getty@tty1".enable = false;
		systemd.services."autovt@tty1".enable = false;

		# Configure keymap in X11
		services.xserver.xkb = {
			layout = "us";
			variant = "";
		};

		# Enable CUPS to print documents.
		services.printing.enable = true;

		# Enable sound with pipewire.
		services.pulseaudio.enable = false;
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			# If you want to use JACK applications, uncomment this
			#jack.enable = true;

			# use the example session manager (no others are packaged yet so this is enabled by default,
			# no need to redefine it in your config for now)
			#media-session.enable = true;
		};
  };
}

