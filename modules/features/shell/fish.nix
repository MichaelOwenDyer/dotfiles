{
  inputs,
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
          {
            name = "eclm";
            src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "theme-eclm";
              rev = "185c84a41947142d75c68da9bc6c59bcd32757e7";
              sha256 = "OBku4wwMROu3HQXkaM26qhL0SIEtz8ShypuLcpbxp78=";
            };
          }
          { name = "colored-man-pages"; src = colored-man-pages.src; }
          { name = "done"; src = done.src; } # Notify when long commands finish
        ];
      };
    };

  flake.modules.nixos.fish-shell = {
    programs.fish.enable = true;
  };

  flake.modules.darwin.fish-shell = {
    programs.fish.enable = true;
  };
}
