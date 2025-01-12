{ config, lib, pkgs, ... }:

{
  config.home-manager.users.${config.username}.programs.git = {
    ## Enable git
    enable = true;
    
    ## Set username and email according to predefined options
    userName = "${config.fullName}";
    userEmail = "michaelowendyer@gmail.com"; # TODO: Change this to use the email from the config

    ## Set up signing key and auto-sign commits
    # signing.key = "${config.const.signingKey}"; TODO: Figure out signing key
    # signing.signByDefault = true;

    ## Extra config
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      url = {
        "https://github.com" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };
}