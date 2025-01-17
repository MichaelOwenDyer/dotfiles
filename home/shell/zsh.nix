{ config, lib, pkgs, ... }:

{
  # Declare configuration options for Zsh and Oh My Zsh under options.profiles.<name>.development.shell.zsh
  options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
    type = attrsOf (submodule {
      options.development.shell.zsh = {
        enable = mkEnableOption "Zsh shell";
        oh-my-zsh = {
          enable = mkEnableOption "Oh My Zsh";
          plugins = mkOption {
            type = listOf str;
            default = [];
            description = "List of Oh My Zsh plugins to install. See https://github.com/ohmyzsh/ohmyzsh/wiki/plugins for a list of plugins.";
          };
        };
      };
    });
  };

  # Configure Zsh and Oh My Zsh for each user profile
  config.home-manager.users = lib.mapAttrs (username: profile: let zshConfig = profile.development.shell.zsh; in {
    programs.zsh = {
      enable = zshConfig.enable;
      oh-my-zsh = {
        enable = zshConfig.oh-my-zsh.enable;
        plugins = zshConfig.oh-my-zsh.plugins;
      };
    };
  }) config.profiles;
}