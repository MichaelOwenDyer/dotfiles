{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./vscode.nix
  ];

  config.profiles.michael = {
    development.git = {
      enable = true;
      name = config.profiles.michael.fullName;
      email = config.profiles.michael.email;
      config = {
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
            "rust"
          ];
      };
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
    packages = with pkgs; [
      nixd # Nix LSP
      nixfmt-rfc-style # Nix formatting
      rustup
    ];
  };
}