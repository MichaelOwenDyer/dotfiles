{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./vscode.nix
    ./helix.nix
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
            "zsh-autosuggestions" # suggests commands as you type
            "sudo" # press esc twice to prefix last command with sudo
            "git" # git aliases and functions
            "gitfast" # faster git commands
            "git-prompt" # displays information about the current git branch
            "git-auto-fetch" # automatically fetches changes from the remote repository
            "rust" # completion for rustup and cargo
            "zoxide" # smarter cd
            "copypath" # copy the path of the current directory or file
            "copyfile" # copy the contents of a file to the clipboard
          ];
      };
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };
    programs.neovim.enable = true;
    packages = with pkgs; [
      nixd # Nix LSP
      nixfmt-rfc-style # Nix formatting
      rustup
    ];
  };
}