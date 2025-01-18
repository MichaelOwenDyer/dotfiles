{ config, lib, pkgs, ... }:

{
	imports = [
		./browser
		./chat
		./development
		./shell
	];

	# Declare basic profile configuration options
	options.profiles = let inherit (lib) mkOption; in with lib.types; mkOption {
		type = attrsOf (submodule {
			options = {
				fullName = mkOption {
					type = str;
					description = "Full name of the user";
				};
				email = mkOption {
					type = str;
					description = "Email address of the user";
				};
				hashedPassword = mkOption {
					type = str;
					description = "Hashed password of the user";
				};
				extraGroups = mkOption {
					type = listOf str;
					default = [
						"wheel"
						"video"
						"audio"
						"input"
					];
					description = "Extra groups to add the user to";
				};
				home.packages = mkOption {
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

		# Configure Home Manager for each user
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.users = lib.mapAttrs (username: profile: {
			# Let Home Manager install and manage itself
			programs.home-manager.enable = true;
			# Allow unfree packages
			nixpkgs.config.allowUnfree = true;
			# Set username
			home.username = username;
			# Set home directory
			home.homeDirectory = "/home/${username}";
			home.packages = profile.home.packages;
			# Set state version for home-manager
			home.stateVersion = config.stateVersion;
		}) config.profiles;
	};
}