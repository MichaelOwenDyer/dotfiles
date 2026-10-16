{
  ...
}:
{
  # Nushell - A modern shell written in Rust with structured data pipelines

  flake.modules.homeManager.nushell =
    { pkgs, config, ... }:
    {
      home.shell.enableNushellIntegration = true;

      programs.nushell = {
        enable = true;

        # Environment configuration
        environmentVariables = {
          EDITOR = "hx";
          VISUAL = "hx";
        };

        # Shell aliases (translated to nushell syntax)
        shellAliases = {
          # Nix operations
          nrs = "nh os switch";
          nrb = "nh os build";
          nrt = "nh os test";
          nfu = "nix flake update";
          nfc = "nix flake check";

          # Systemd (Linux)
          sc = "systemctl";
          scu = "systemctl --user";
          jc = "journalctl";
          jcf = "journalctl -f";

          # Navigation
          dots = "cd ~/.dotfiles";
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";

          # Git shortcuts
          g = "git";
          ga = "git add";
          gc = "git commit";
          gco = "git checkout";
          gd = "git diff";
          gf = "git fetch";
          gl = "git log --oneline";
          gp = "git push";
          gpl = "git pull";
          gs = "git status";
          gst = "git stash";

          # Safety nets
          rm = "rm -i";
          mv = "mv -i";
          cp = "cp -i";
        };

        # Main configuration
        extraConfig = ''
          # ─────────────────────────────────────────────────────────────────
          # Nushell Configuration
          # ─────────────────────────────────────────────────────────────────

          $env.config = {
            show_banner: false

            # Completions
            completions: {
              case_sensitive: false
              quick: true
              partial: true
              algorithm: "fuzzy"
            }

            # History
            history: {
              max_size: 100000
              sync_on_enter: true
              file_format: "sqlite"
              isolation: false
            }

            # Table display
            table: {
              mode: rounded
              index_mode: always
              show_empty: true
              padding: { left: 1, right: 1 }
              trim: {
                methodology: wrapping
                wrapping_try_keep_words: true
              }
              header_on_separator: false
            }

            # Error display
            error_style: "fancy"

            # Cursor shape
            cursor_shape: {
              emacs: line
              vi_insert: line
              vi_normal: block
            }

            # Edit mode (emacs or vi)
            edit_mode: emacs

            # Hooks
            hooks: {
              pre_prompt: []
              pre_execution: []
              env_change: {
                PWD: [
                  # Auto-ls on directory change (optional, can be commented out)
                  # { |before, after| ls }
                ]
              }
            }

            # Keybindings
            keybindings: [
              {
                name: fuzzy_history
                modifier: control
                keycode: char_r
                mode: [emacs, vi_insert, vi_normal]
                event: {
                  send: ExecuteHostCommand
                  cmd: "commandline edit --replace (
                    history
                    | get command
                    | reverse
                    | uniq
                    | str join (char -i 0)
                    | fzf --read0 --layout=reverse --height=40% -q (commandline)
                    | decode utf-8
                    | str trim
                  )"
                }
              }
              {
                name: fuzzy_file
                modifier: control
                keycode: char_t
                mode: [emacs, vi_insert, vi_normal]
                event: {
                  send: ExecuteHostCommand
                  cmd: "commandline edit --insert (fd --type f --hidden --follow --exclude .git | fzf --layout=reverse --height=40%)"
                }
              }
            ]
          }

          # ─────────────────────────────────────────────────────────────────
          # Custom Commands
          # ─────────────────────────────────────────────────────────────────

          # Create directory and cd into it
          def --env mkcd [dir: string] {
            mkdir $dir
            cd $dir
          }

          # Fuzzy find and kill process
          def fkill [] {
            let selection = (ps | where name != "nu" | select pid name cpu | to text | fzf --header="Select process to kill" | str trim)
            if ($selection | is-not-empty) {
              let pid = ($selection | split row " " | first | into int)
              kill $pid
              print $"Killed process ($pid)"
            }
          }

          # Git worktree helper
          def gwt [branch: string] {
            let worktree_path = $"../($branch)"
            if ($worktree_path | path exists) {
              cd $worktree_path
            } else {
              try {
                git worktree add $worktree_path $branch
              } catch {
                git worktree add -b $branch $worktree_path
              }
              cd $worktree_path
            }
          }

          # Build NixOS config and show package diff
          def nrsd [] {
            nh os build
            nvd diff /run/current-system result
          }

          # Quick file search with preview
          def ff [pattern?: string] {
            if ($pattern | is-empty) {
              fd --type f --hidden --follow --exclude .git | fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"
            } else {
              fd --type f --hidden --follow --exclude .git $pattern | fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"
            }
          }

          # Quick grep with fzf
          def rgi [pattern: string] {
            rg --color=always --line-number --no-heading $pattern | fzf --ansi --preview "bat --color=always {1} --highlight-line {2}" --preview-window '+{2}-/2'
          }

          # Show disk usage in a nice table
          def duf [] {
            df -h | from ssv | where Filesystem !~ "^(tmpfs|devtmpfs|overlay)" | select Filesystem Size Used Avail "Use%" Mounted
          }

          # Quick HTTP server
          def serve [port?: int] {
            let p = ($port | default 8000)
            print $"Serving on http://localhost:($p)"
            python3 -m http.server $p
          }

          # Extract various archive formats
          def extract [file: path] {
            let ext = ($file | path parse | get extension)
            match $ext {
              "tar" => { tar xvf $file },
              "gz" => {
                if ($file | str ends-with ".tar.gz") or ($file | str ends-with ".tgz") {
                  tar xzvf $file
                } else {
                  gunzip $file
                }
              },
              "tgz" => { tar xzvf $file },
              "bz2" => { tar xjvf $file },
              "xz" => { tar xJvf $file },
              "zip" => { unzip $file },
              "7z" => { 7z x $file },
              "rar" => { unrar x $file },
              _ => { print $"Unknown archive format: ($ext)" }
            }
          }

          # Weather in terminal
          def weather [location?: string] {
            let loc = ($location | default "")
            http get $"https://wttr.in/($loc)?format=3"
          }

          # ─────────────────────────────────────────────────────────────────
          # Prompt Configuration (if not using Starship)
          # ─────────────────────────────────────────────────────────────────

          # Note: If you use Starship, it will override this prompt.
          # This is a fallback prompt for when Starship is not available.

          def create_left_prompt [] {
            let dir = ($env.PWD | path relative-to $env.HOME | if ($in | is-empty) { "~" } else { $"~/($in)" })
            let git_branch = (do { git branch --show-current } | complete | if $in.exit_code == 0 { $" (ansi cyan)($in.stdout | str trim)(ansi reset)" } else { "" })

            $"(ansi green_bold)($dir)(ansi reset)($git_branch) "
          }

          def create_right_prompt [] {
            let time = (date now | format date "%H:%M:%S")
            $"(ansi white_dimmed)($time)(ansi reset)"
          }

          # Use custom prompt only if Starship is not initialized
          # (Starship sets STARSHIP_SESSION_KEY)
          if "STARSHIP_SESSION_KEY" not-in $env {
            $env.PROMPT_COMMAND = { || create_left_prompt }
            $env.PROMPT_COMMAND_RIGHT = { || create_right_prompt }
          }

          $env.PROMPT_INDICATOR = "❯ "
          $env.PROMPT_INDICATOR_VI_INSERT = ": "
          $env.PROMPT_INDICATOR_VI_NORMAL = "❯ "
          $env.PROMPT_MULTILINE_INDICATOR = "::: "
        '';

        # Environment file configuration
        extraEnv = ''
          # ─────────────────────────────────────────────────────────────────
          # Environment Setup
          # ─────────────────────────────────────────────────────────────────

          # XDG directories
          $env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
          $env.XDG_DATA_HOME = ($env.HOME | path join ".local" "share")
          $env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
          $env.XDG_STATE_HOME = ($env.HOME | path join ".local" "state")

          # Ensure nushell config dirs exist
          mkdir ($env.XDG_CONFIG_HOME | path join "nushell")
          mkdir ($env.XDG_DATA_HOME | path join "nushell")

          # Carapace completions (if available)
          if (which carapace | is-not-empty) {
            $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
            mkdir ~/.cache/carapace
            carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
          }
        '';
      };

      # Additional packages that enhance nushell experience
      home.packages = with pkgs; [
        carapace # Multi-shell completion generator
      ];
    };

  flake.modules.nixos.nushell = {
    programs.nushell.enable = true;
  };

  flake.modules.darwin.nushell =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.nushell ];
    };
}
