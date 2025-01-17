## This default configuration is included when one or more user profiles are present on the system.
## It registers user accounts on the system and configures home manager for each user individually.

{ config, lib, pkgs, ... }:

{

	# Register a user account for each profile
	users.users = lib.mapAttrs (username: profile: {
		isNormalUser = true;
		description = profile.fullName;
		hashedPassword = profile.hashedPassword;
		extraGroups = [
			"wheel"
			"video"
			"audio"
			"input"
		] ++ lib.optionals config.networking.networkmanager.enable [
			# If networkmanager is enabled, add every user to the networkmanager group # TODO: Make this by-user
			"networkmanager"
		];
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
		home.packages = with pkgs; [
			# User packages for all profiles
		] ++ lib.optionals config.networking.networkmanager.enable [
			# If networkmanager is enabled, add networkmanagerapplet to every user's home packages # TODO: Make this by-user
			networkmanagerapplet
		];
		# Set state version for home-manager
		home.stateVersion = config.stateVersion;
	}) config.profiles;
}

