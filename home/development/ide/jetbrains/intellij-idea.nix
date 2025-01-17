{ config, settings, lib, pkgs, ... }:

{
	# Declare configuration options for JetBrains IntelliJ IDEA under options.profiles.<name>.development.ide.jetbrains.intellij-idea
	options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
		type = attrsOf (submodule {
			options.development.ide.jetbrains.intellij-idea = {
				enable = mkEnableOption "IntelliJ IDEA";
				plugins = mkOption {
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
			allPlugins = jetbrainsConfig.default-plugins ++ jetbrainsConfig.intellij-idea.plugins;
			# Construct the IntelliJ IDEA package with all plugins
			ideaPkg = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate allPlugins;
		in {
			# Add IntelliJ IDEA to the user's home packages
			home.packages = [ ideaPkg ];
		}
	) config.profiles;
}