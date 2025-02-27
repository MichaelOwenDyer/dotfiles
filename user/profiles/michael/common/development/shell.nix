{
  config,
  lib,
  ...
}:

{
  config.profiles.michael = {
    development.shell.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins =
          [
            "sudo"
            "git"
            "git-prompt"
          ]
          ++ lib.optionals config.profiles.michael.development.lang.rust.enable [
            "rust"
          ];
      };
    };
  };
}