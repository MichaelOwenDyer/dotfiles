{ config, lib, pkgs, ... }:

{
	# Declare configuration options for Rust under options.profiles.<name>.development.lang.rust
	options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
		type = attrsOf (submodule {
			options.development.lang.rust = {
				enable = mkEnableOption "Rust programming language support";
			};
		});
	};

	# Configure Rust for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: let rustConfig = profile.development.lang.rust; in {
		# Install Rustup for the user if enabled
		home.packages = lib.optionals rustConfig.enable [
			pkgs.rustup
		];
	}) config.profiles;
}