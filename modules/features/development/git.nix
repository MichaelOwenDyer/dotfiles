{
  ...
}:
let
  settings = {
    init.defaultBranch = "main";
    pull.rebase = true;
    rebase.autoStash = true; # Stash changes before rebase, restore after
    push.default = "current";
    push.autoSetupRemote = true;

    # Better diffs
    diff.algorithm = "histogram";
    diff.colorMoved = "default";

    # Merge settings
    merge.conflictstyle = "zdiff3"; # Show common ancestor in conflicts
    merge.algorithm = "patience";
    rerere.enabled = true; # Remember conflict resolutions

    # UX improvements
    help.autocorrect = 15; # Auto-correct typos after 1.5s
    log.abbrevCommit = true;
    log.decorate = true;

    # URL shortcuts
    url = {
      "https://github.com/" = {
        insteadOf = [ "gh:" "github:" ];
      };
      "git@github.com:" = {
        pushInsteadOf = "https://github.com/"; # Use SSH for pushes
      };
    };

    alias = {
      s = "status -sb";
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      amend = "commit --amend --no-edit";
      undo = "reset --soft HEAD~1";
      today = "log --since=midnight --author='.*' --oneline";
      fp = "fetch --prune";
      ri = "rebase -i";
    };
  };
in
{
  flake.modules.nixos.git = {
    programs.git = {
      enable = true;
      config = settings;
    };
  };

  flake.modules.darwin.git =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];
    };

  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      inherit settings;
    };

    # Syntax-highlighted diffs
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        navigate = true;
        side-by-side = false;
        line-numbers = true;
      };
    };
  };
}
