{
  shellAliases ? {},
  ...
}:

{
  home.shell.enableZshIntegration = true;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    inherit shellAliases;

    history = {
      path = "$HOME/.zsh_history"; # Save history to this file
      size = 10000; # Maximum number of commands to save
      ignoreDups = true; # Don't save the same command twice in a row
      ignoreSpace = true; # Don't save commands that start with a space
      ignorePatterns = [
        "rm *"
        "pkill *"
        "cp *"
      ]; # Do not save these commands to history
    };

    autosuggestion = {
      enable = true;
      strategy = [
        "history" # Suggest commands from history
        "completion" # Suggest tab completions second
      ];
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
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
}
