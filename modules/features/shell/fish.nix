{
  inputs,
  ...
}:
{
  # Fish shell configuration - modern, user-friendly shell

  flake.modules.homeManager.fish-shell =
    { pkgs, ... }:
    {
      home.shell.enableFishIntegration = true;
      home.packages = [ pkgs.grc ];

      programs.fish = {
        enable = true;

        interactiveShellInit = ''
          # Disable greeting message
          set fish_greeting

          # Use vi keybindings with emacs-style insert mode
          # Benefit: Best of both worlds - vi motions, familiar insert behavior
          fish_hybrid_key_bindings

          # Enable direnv integration (if direnv is enabled)
          # Benefit: Auto-load dev environments when entering project directories
          if type -q direnv
            direnv hook fish | source
          end
        '';

        # Shell abbreviations (expand when typed, unlike aliases)
        # Benefit: Visible expansion teaches muscle memory, appears in history expanded
        shellAbbrs = {
          # Nix shortcuts
          nrs = "nh os switch";
          nrb = "nh os build";
          nrt = "nh os test";
          nfu = "nix flake update";
          nfc = "nix flake check";

          # System shortcuts
          sc = "systemctl";
          scu = "systemctl --user";
          jc = "journalctl";
          jcf = "journalctl -f"; # Follow logs

          # Quick edits
          dots = "cd ~/.dotfiles";
        };

        # Functions for complex operations
        functions = {
          # Quick directory creation and navigation
          # Usage: mkcd my-new-directory
          mkcd = ''
            function mkcd --description "Create directory and cd into it"
              mkdir -p $argv[1] && cd $argv[1]
            end
          '';

          # Find and kill process by name
          # Usage: fkill firefox
          fkill = ''
            function fkill --description "Fuzzy find and kill process"
              set -l pid (ps aux | fzf --header='Select process to kill' | awk '{print $2}')
              if test -n "$pid"
                kill -9 $pid
                echo "Killed process $pid"
              end
            end
          '';

          # Git worktree helper
          # Usage: gwt feature-branch
          gwt = ''
            function gwt --description "Create or switch to git worktree"
              set -l branch $argv[1]
              set -l worktree_path "../$branch"
              if test -d $worktree_path
                cd $worktree_path
              else
                git worktree add $worktree_path $branch 2>/dev/null
                or git worktree add -b $branch $worktree_path
                cd $worktree_path
              end
            end
          '';

          # Rebuild NixOS and show diff
          # Usage: nrsd (NixOS Rebuild Show Diff)
          nrsd = ''
            function nrsd --description "Build NixOS config and show package diff"
              nh os build && nvd diff /run/current-system result
            end
          '';
        };

        plugins = with pkgs.fishPlugins; [
          {
            # Colorize command output (ls, diff, make, etc.)
            name = "grc";
            src = grc.src;
          }
          {
            # Remove failed commands from history
            # Benefit: Keeps history clean of typos and mistakes
            name = "sponge";
            src = sponge.src;
          }
          {
            # Press Esc twice to prefix command with sudo
            # Benefit: Quick privilege escalation without retyping
            name = "sudope";
            src = plugin-sudope.src;
          }
          {
            # Git abbreviations and completions
            name = "git";
            src = plugin-git.src;
          }
          {
            # Theme
            name = "eclm";
            src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "theme-eclm";
              rev = "185c84a41947142d75c68da9bc6c59bcd32757e7";
              sha256 = "OBku4wwMROu3HQXkaM26qhL0SIEtz8ShypuLcpbxp78=";
            };
          }
          {
            # Colored man pages
            # Benefit: Syntax highlighting in man pages for readability
            name = "colored-man-pages";
            src = colored-man-pages.src;
          }
          {
            # Notify when long-running commands finish
            # Benefit: Start a build, switch windows, get notified when done
            name = "done";
            src = done.src;
          }
        ];
      };
    };

  # NixOS needs fish enabled for users to use it as shell
  flake.modules.nixos.fish-shell = {
    programs.fish.enable = true;
  };

  flake.modules.darwin.fish-shell = {
    programs.fish.enable = true;
  };
}
