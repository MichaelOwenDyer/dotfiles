{ config, lib, pkgs, ... }:

{
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