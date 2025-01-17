{ config, lib, pkgs, ... }:

{
  config.home-manager.users = lib.mapAttrs (username: profile: let gitConfig = profile.development.git; in {
    programs.git = {
      # Enable git for the user
      enable = gitConfig.enable;
      # Set username and email according to predefined options
      userName = gitConfig.name;
      userEmail = gitConfig.email;
      # TODO: Set up signing key and auto-sign commits
      # Set extra configuration options
      extraConfig = gitConfig.extraConfig;
    };
  }) config.profiles;
}