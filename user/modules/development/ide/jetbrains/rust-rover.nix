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
			# Get the RustRover configuration for the profile
			cfg = profile.development.ide.jetbrains.rust-rover;
			# Combine the user's default Jetbrains plugins with the user's RustRover plugins
			plugins = profile.development.ide.jetbrains.plugins ++ cfg.plugins;
			# Use nix-jetbrains-plugins helper
			mkIde = nix-jetbrains-plugins.lib."${config.hostPlatform}".buildIdeWithPlugins;
			# Construct the RustRover package with all plugins
			rust-rover = mkIde pkgs.jetbrains "rust-rover" plugins;
		in lib.mkIf cfg.enable {
			# Add RustRover to the user's home packages
			home.packages = [ rust-rover ];
		}
	) config.profiles;
}
