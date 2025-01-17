{ config, lib, pkgs, ... }:

{
	# Declare configuration options for Java under options.profiles.<name>.development.lang.java
	options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
		type = attrsOf (submodule {
			options.development.lang.java = {
				enable = mkEnableOption "Java programming language support";
				mainPackage = mkOption {
					type = package;
					description = "Main Java package to install. Will be used as JAVA_HOME.";
				};
				additionalPackages = mkOption {
					type = listOf package;
					default = [];
					description = "Additional Java packages to install.";
				};
			};
		});
	};

	# Configure Java for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: let javaConfig = profile.development.lang.java; in {
		# Enable Java for the user
		programs.java.enable = javaConfig.enable;
		# Add the main Java version to the PATH
		programs.java.package = javaConfig.mainPackage;
		# Install all additional Java versions (not in the PATH)
		home.packages = lib.optionals javaConfig.enable javaConfig.additionalPackages;
	}) config.profiles;
}