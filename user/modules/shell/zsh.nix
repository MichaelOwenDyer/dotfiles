{ config, lib, pkgs, ... }:

{
	# Declare configuration options for Zsh and Oh My Zsh under options.profiles.<name>.development.shell.zsh
	options.profiles = with lib.types; lib.mkOption {
		type = attrsOf (submodule {
			options.development.shell.zsh = {
				enable = lib.mkEnableOption "Zsh shell";
				oh-my-zsh = {
					enable = lib.mkEnableOption "Oh My Zsh";
					theme = lib.mkOption {
						type = str;
						description = "Oh My Zsh theme to use. See https://github.com/ohmyzsh/ohmyzsh/wiki/themes for a list of themes.";
					};
					plugins = lib.mkOption {
						type = listOf str;
						default = [];
						description = "List of Oh My Zsh plugins to install. See https://github.com/ohmyzsh/ohmyzsh/wiki/plugins for a list of plugins.";
					};
				};
			};
		});
	};

	config = lib.mkIf (lib.any (profile: profile.development.shell.zsh.enable) (lib.attrValues config.profiles)) {
		# Enable Zsh globally if Zsh is enabled in any profile
		programs.zsh.enable = true;

		# Set the user shell to Zsh for those profiles that have it enabled
		users.users = lib.mapAttrs (username: profile: let cfg = profile.development.shell.zsh; in lib.mkIf cfg.enable {
			shell = pkgs.zsh;
		}) config.profiles;

		# Configure Zsh and Oh My Zsh for each user profile using Home Manager
		home-manager.users = lib.mapAttrs (username: profile: let cfg = profile.development.shell.zsh; in lib.mkIf cfg.enable {
			programs.zsh = {
				enable = true;
				enableCompletion = true;
				syntaxHighlighting.enable = true;
				shellAliases = profile.development.shellAliases;

				history = {
					path = "$HOME/.zsh_history"; # Save history to this file
					size = 10000; # Maximum number of commands to save
					ignoreDups = true; # Don't save the same command twice in a row
					ignoreSpace = true; # Don't save commands that start with a space
					ignorePatterns = [ "rm *" "pkill *" "cp *" ]; # Do not save these commands to history
				};

				autosuggestion = {
					enable = true;
					strategy = [
						"history" # Suggest commands from history
						"completion" # Suggest tab completions second
					];
				};

				oh-my-zsh = lib.mkIf cfg.oh-my-zsh.enable {
					enable = true;
					plugins = cfg.oh-my-zsh.plugins;
					theme = cfg.oh-my-zsh.theme;
				};
			};
		}) config.profiles;
	};
}