{ config, lib, pkgs, ... }:

{
	imports = [
		./intellij-idea.nix
		./rust-rover.nix
	];

	# Declare configuration options for JetBrains IDEs under options.profiles.<name>.development.ide.jetbrains
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.ide.jetbrains.plugins = lib.mkOption {
				type = listOf str;
				default = [];
				description = "Plugins to install in all JetBrains IDEs";
			};
		});
	};
}