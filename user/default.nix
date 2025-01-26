{ config, lib, pkgs, ... }:

{
	imports = [
		./browser
		./chat
		./development
		./shell
    ./caffeine.nix
	];

	# Declare basic profile configuration options
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options = {
				fullName = lib.mkOption {
					type = str;
					description = "Full name of the user";
				};
				email = lib.mkOption {
					type = str;
					description = "Email address of the user";
				};
				hashedPassword = lib.mkOption {
					type = str;
					description = "Hashed password of the user";
				};
				extraGroups = lib.mkOption {
					type = listOf str;
					default = [
						"wheel"
						"video"
						"audio"
						"input"
					];
					description = "Extra groups to add the user to";
				};
				home.packages = lib.mkOption {
					type = listOf package;
					default = [];
					description = "Packages to install for the user";
				};
			};
		});
	};

	config = {
		# Register a system user account for each profile
		users.users = lib.mapAttrs (username: profile: {
			isNormalUser = true;
			description = profile.fullName;
			hashedPassword = profile.hashedPassword;
			extraGroups = profile.extraGroups;
		}) config.profiles;

    # By default, home manager wants to use a separate nixpkgs instance for each user, but this tells it to use the system nixpkgs
		home-manager.useGlobalPkgs = true;
    # By default, home manager will install packages in /home/<username>/.nix-profile, but this puts them in /etc/profiles
		home-manager.useUserPackages = true;

		# Configure home manager for each profile
		home-manager.users = lib.mapAttrs (username: profile: {
			# Let home manager install and manage itself
			programs.home-manager.enable = true;
			# Allow unfree packages
			nixpkgs.config.allowUnfree = true;
			# Set username
			home.username = username;
			# Set home directory
			home.homeDirectory = "/home/${username}";
      # Set home packages
			home.packages = profile.home.packages;
			# Set state version for home-manager as the system state version
			home.stateVersion = config.system.stateVersion;
		}) config.profiles;
	};
}