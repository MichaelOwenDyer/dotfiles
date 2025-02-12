{ config, lib, pkgs, ... }:

{
	# Declare configuration options for Java under options.profiles.<name>.development.lang.java
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.lang.java = {
				enable = lib.mkEnableOption "Java programming language support";
				mainPackage = lib.mkOption {
					type = package;
					description = "Main Java package to install. Will be used as JAVA_HOME.";
				};
				additionalPackages = lib.mkOption {
					type = listOf package;
					default = [];
					description = "Additional Java packages to install.";
				};
			};
		});
	};

	# Configure Java for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile: let cfg = profile.development.lang.java; in lib.mkIf cfg.enable {
		# Enable Java for the user
		programs.java.enable = true;
		# Add the main Java version to the PATH
		programs.java.package = cfg.mainPackage;
		# Install all additional Java versions (not in the PATH)
		home.packages = cfg.additionalPackages;
	}) config.profiles;
}