{ config, lib, pkgs, ... }:

{
	imports = [
		./intellij-idea.nix
		./rust-rover.nix
	];

	# Declare configuration options for JetBrains IDEs under options.profiles.<name>.development.ide.jetbrains
	options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
		type = attrsOf (submodule {
			options.development.ide.jetbrains.default-plugins = mkOption {
				type = listOf str;
				default = [];
				description = "Plugins to install in all JetBrains IDEs";
			};
		});
	};
}