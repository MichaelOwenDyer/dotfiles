{
  ...
}:
{
  # Fish shell

  flake.modules.homeManager.fish-shell =
    { pkgs, ... }:
    {
      home.shell.enableFishIntegration = true;
      home.packages = [ pkgs.grc ];

      programs.fish = {
        enable = true;

        interactiveShellInit = ''
          set fish_greeting
          fish_hybrid_key_bindings

          # Direnv integration if available
          if type -q direnv
            direnv hook fish | source
          end
        '';

        shellAbbrs = {
          # Nix
          nrs = "nh os switch";
          nrb = "nh os build";
          nrt = "nh os test";
          nfu = "nix flake update";
          nfc = "nix flake check";

          # Systemd
          sc = "systemctl";
          scu = "systemctl --user";
          jc = "journalctl";
          jcf = "journalctl -f";

          dots = "cd ~/.dotfiles";
        };

        functions = {
          # Custom prompt that always shows hostname
          fish_prompt = ''
            set -l last_status $status
            set -l normal (set_color normal)
            set -l cyan (set_color cyan)
            set -l green (set_color green)
            set -l red (set_color red)
            set -l yellow (set_color yellow)

            # Hostname in cyan
            echo -n -s $cyan (hostname -s) $normal ':'

            # Current directory in green
            echo -n -s $green (prompt_pwd) $normal

            # Git branch if in a repo
            if git rev-parse --git-dir >/dev/null 2>&1
              set -l branch (git branch --show-current 2>/dev/null)
              if test -n "$branch"
                echo -n -s ' ' $yellow '(' $branch ')' $normal
              end
            end

            # Prompt character (red if last command failed)
            if test $last_status -eq 0
              echo -n -s ' ' $green '❯' $normal ' '
            else
              echo -n -s ' ' $red '❯' $normal ' '
            end
          '';

          mkcd = ''
            function mkcd --description "Create directory and cd into it"
              mkdir -p $argv[1] && cd $argv[1]
            end
          '';

          fkill = ''
            function fkill --description "Fuzzy find and kill process"
              set -l pid (ps aux | fzf --header='Select process to kill' | awk '{print $2}')
              if test -n "$pid"
                kill -9 $pid
                echo "Killed process $pid"
              end
            end
          '';

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

          nrsd = ''
            function nrsd --description "Build NixOS config and show package diff"
              nh os build && nvd diff /run/current-system result
            end
          '';
        };

        plugins = with pkgs.fishPlugins; [
          { name = "grc"; src = grc.src; }
          { name = "sponge"; src = sponge.src; } # Remove failed commands from history
          { name = "sudope"; src = plugin-sudope.src; } # Esc-Esc to prefix with sudo
          { name = "git"; src = plugin-git.src; }
          { name = "colored-man-pages"; src = colored-man-pages.src; }
          { name = "done"; src = done.src; } # Notify when long commands finish
        ];
      };
    };

  flake.modules.nixos.fish-shell = {
    programs.fish.enable = true;
    impermanence.ephemeralPaths = [ "/etc/fish" ];
  };

  flake.modules.darwin.fish-shell = {
    programs.fish.enable = true;
  };
}
