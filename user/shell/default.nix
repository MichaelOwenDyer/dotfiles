{ config, lib, pkgs, ... }:

{
	imports = [
		./zsh.nix
	];

	# Declare configuration options for all shells
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.shell = {
        aliases = lib.mkOption {
          type = attrsOf str;
          default = {};
          description = "Aliases to add for all shells";
        };
      };
		});
	};

  # Configure shell aliases for all shells for each user profile
  config.home-manager.users = lib.mapAttrs (username: profile: {
    home.shellAliases = profile.development.shell.aliases;
  }) config.profiles;
}