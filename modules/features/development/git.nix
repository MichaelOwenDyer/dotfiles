{
  ...
}:
let
  settings = {
    init.defaultBranch = "main";

    # Rebase by default on pull (keeps history linear)
    # Benefit: Cleaner git history, easier to follow
    pull.rebase = true;

    # Autostash before rebase, restore after
    # Benefit: No need to manually stash/unstash when pulling with changes
    rebase.autoStash = true;

    # Push current branch to same-named remote branch
    # Benefit: `git push` works without specifying branch
    push.default = "current";

    # Auto-setup remote tracking on first push
    # Benefit: `git push` works on new branches without -u
    push.autoSetupRemote = true;

    # Sign commits if GPG key is available (can be overridden per-repo)
    # commit.gpgsign = true;

    # Better diff algorithm for more readable diffs
    # Benefit: Smarter diff output, especially for moved code
    diff.algorithm = "histogram";

    # Show moved lines in different color
    # Benefit: Easy to spot code that was moved vs changed
    diff.colorMoved = "default";

    # Automatically correct typos in commands (after 1.5s delay)
    # Benefit: `git stauts` becomes `git status`
    help.autocorrect = 15;

    # Remember conflict resolutions and replay them
    # Benefit: Don't re-resolve the same conflicts during rebase
    rerere.enabled = true;

    # Nicer merge conflict markers showing common ancestor
    # Benefit: Easier to understand 3-way merge conflicts
    merge.conflictstyle = "zdiff3";

    # Use patience algorithm for merges (better for large changes)
    merge.algorithm = "patience";

    # Abbreviate object names in logs
    # Benefit: Readable short hashes in output
    log.abbrevCommit = true;

    # Show branch/tag names in log
    log.decorate = true;

    # Shorthand URLs
    url = {
      "https://github.com/" = {
        insteadOf = [
          "gh:"
          "github:"
        ];
      };
      "git@github.com:" = {
        # Use SSH for pushing to GitHub (requires SSH key)
        # Benefit: No password prompts, secure auth
        pushInsteadOf = "https://github.com/";
      };
    };

    # Aliases for common operations
    alias = {
      # Concise status
      s = "status -sb";
      # Pretty log graph
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      # Amend without editing message
      amend = "commit --amend --no-edit";
      # Undo last commit (keep changes staged)
      undo = "reset --soft HEAD~1";
      # Show what I did today
      today = "log --since=midnight --author='.*' --oneline";
      # Fetch and prune dead remote branches
      fp = "fetch --prune";
      # Interactive rebase on last n commits
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

      # Delta for syntax-highlighted diffs
      # Benefit: Much more readable diffs with colors and line numbers
      delta = {
        enable = true;
        options = {
          navigate = true;
          side-by-side = false;
          line-numbers = true;
        };
      };
    };
  };
}
