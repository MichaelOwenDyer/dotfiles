{ config, lib, pkgs, ... }:

{
  config.home-manager.users.${config.username}.programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      # See https://github.com/ohmyzsh/ohmyzsh/wiki/plugins for a list of plugins
      plugins = [
        "sudo"
        "git"
        "git-prompt"
      ]
      ++ lib.optionals config.development.lang.rust.enable [ "rust" ];
    };
  };
}