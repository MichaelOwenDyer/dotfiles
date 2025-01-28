{ config, lib, pkgs, nix-jetbrains-plugins, ... }:

{
	# Declare configuration options for RustRover under options.profiles.<name>.development.ide.jetbrains.rust-rover
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.ide.jetbrains.rust-rover = {
				enable = lib.mkEnableOption "RustRover IDE";
				# See all available plugins at
				# https://raw.githubusercontent.com/theCapypara/nix-jetbrains-plugins/refs/heads/main/generated/all_plugins.json
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
			# Use nix-jetbrains-plugins helper
			mkIde = nix-jetbrains-plugins.lib."${pkgs.hostPlatform}".buildIdeWithPlugins;
			# Construct the RustRover package with all plugins
			rustRoverPkg = mkIde pkgs.jetbrains "rust-rover" allPlugins;
		in lib.mkIf jetbrainsConfig.rust-rover.enable {
			# Add RustRover to the user's home packages
			home.packages = [ rustRoverPkg ];
		}
	) config.profiles;
}
