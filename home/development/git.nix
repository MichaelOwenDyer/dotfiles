{ config, lib, pkgs, ... }:

{
	# Declare configuration options for Git under options.profiles.<name>.development.git
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.git = {
				enable = lib.mkEnableOption "Git support";
				name = lib.mkOption {
					type = str;
					description = "Name to use with Git";
					# default = config.profiles.<username>.fullName; TODO: Would be nice to be able to reuse config.profiles.<name>.fullName here but we don't have access to the username
				};
				email = lib.mkOption {
					type = str;
					description = "Email to use with Git";
				};
				config = lib.mkOption {
					type = attrs;
					default = {};
					description = "Extra Git configuration";
				};
			};
		});
	};

	# Configure Git for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: let gitConfig = profile.development.git; in {
		programs.git = {
			# Enable git for the user
			enable = gitConfig.enable;
			# Set username and email according to predefined options
			userName = gitConfig.name;
			userEmail = gitConfig.email;
			# TODO: Set up signing key and auto-sign commits
			# Set extra configuration options
			extraConfig = gitConfig.config;
		};
	}) config.profiles;
}