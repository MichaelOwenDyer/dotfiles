{ config, lib, pkgs, ... }:

{
	# Declare configuration options for RustRover under options.profiles.<name>.development.ide.jetbrains.rust-rover
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.ide.jetbrains.rust-rover = {
				enable = lib.mkEnableOption "RustRover IDE";
				plugins = lib.mkOption {
					type = listOf str;
					default = [];
					description = "Plugins to install with RustRover";
				};
			};
		});
	};

	# Configure RustRover for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile:
		let
			# Get the Jetbrains configuration for the profile
			jetbrainsConfig = profile.development.ide.jetbrains;
			# Combine the user's default Jetbrains plugins with the user's RustRover plugins
			allPlugins = jetbrainsConfig.plugins ++ jetbrainsConfig.rust-rover.plugins;
			# Construct the RustRover package with all plugins
			rustRoverPkg = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rust-rover allPlugins;
		in {
			# Add RustRover to the user's home packages
			home.packages = [ rustRoverPkg ];
		}
	) config.profiles;
}