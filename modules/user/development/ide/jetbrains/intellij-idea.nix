{ config, lib, pkgs, nix-jetbrains-plugins, ... }:

{
	# Declare configuration options for JetBrains IntelliJ IDEA under options.profiles.<name>.development.ide.jetbrains.intellij-idea
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.ide.jetbrains.intellij-idea = {
				enable = lib.mkEnableOption "IntelliJ IDEA";
				# See all available plugins at
				# https://raw.githubusercontent.com/theCapypara/nix-jetbrains-plugins/refs/heads/main/generated/all_plugins.json
				plugins = lib.mkOption {
					type = listOf str;
					default = [];
					description = "Plugins to install in IntelliJ IDEA";
				};
			};
		});
	};

	# Configure JetBrains IntelliJ IDEA for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile:
		let
			# Get the JetBrains configuration for the profile
			jetbrainsConfig = profile.development.ide.jetbrains;
			# Combine the user's default Jetbrains plugins with the user's IntelliJ IDEA plugins
			allPlugins = jetbrainsConfig.plugins ++ jetbrainsConfig.intellij-idea.plugins;
			# Use nix-jetbrains-plugins helper
			mkIde = nix-jetbrains-plugins.lib."${pkgs.hostPlatform}".buildIdeWithPlugins;
			# Construct the IntelliJ IDEA package with all plugins
			ideaPkg = mkIde pkgs.jetbrains "intellij-idea" allPlugins;
		in lib.mkIf jetbrainsConfig.intellij-idea.enable {
			# Add IntelliJ IDEA to the user's home packages
			home.packages = [ ideaPkg ];
		}
	) config.profiles;
}
