{
  ...
}:
{
  flake.modules.nixos.yazi = {
    programs.yazi.enable = true;
  };

  flake.modules.darwin.yazi =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.yazi ];
    };

  flake.modules.homeManager.yazi =
    { pkgs, ... }:
    {
      programs.yazi = {
        enable = true;
        settings = {
          mgr = {
            show_hidden = true;
            show_symlink = true;
            sort_dir_first = true;
          };
          plugin = {
            # Note: Home Manager uses 'name' but yazi expects 'url'
            # Using 'url' directly here since settings are passed through as-is
            prepend_fetchers = [
              {
                id = "git";
                url = "*";
                run = "git";
              }
              {
                id = "git";
                url = "*/";
                run = "git";
              }
            ];
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            # gitui - open gitui in current directory
            # Using shell --block to properly handle terminal
            {
              on = "G";
              run = "shell --block gitui";
              desc = "Open gitui";
            }
            # diff - diff selected file with hovered file
            {
              on = "D";
              run = "plugin diff";
              desc = "Diff selected with hovered file";
            }
            # compress - create archive from selected files
            {
              on = "C";
              run = "plugin compress";
              desc = "Compress selected files";
            }
            # sudo - run operations with elevated privileges
            {
              on = [ "s" "p" ];
              run = "plugin sudo -- paste";
              desc = "Paste with sudo";
            }
            {
              on = [ "s" "d" ];
              run = "plugin sudo -- remove";
              desc = "Delete with sudo";
            }
            {
              on = [ "s" "r" ];
              run = "plugin sudo -- rename";
              desc = "Rename with sudo";
            }
          ];
        };
        initLua = ''
          require("git"):setup()
        '';
        plugins = {
          inherit (pkgs.yaziPlugins)
            git
            sudo
            ouch
            diff
            gitui
            compress
            ;
        };
        flavors = {
          inherit (pkgs.yaziPlugins) nord;
        };
        theme = {
          flavor = {
            light = "nord";
            dark = "nord";
          };
        };
      };
      # enable y shell wrapper that provides the ability to
      # change the current working directory when exiting Yazi.
      programs.fish.interactiveShellInit = ''
        function y
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          command yazi $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        end
      '';
      programs.bash.initExtra = ''
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d ''' cwd < "$tmp"
          [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }
      '';
      programs.zsh.initContent = ''
        function y() {
          local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
          command yazi "$@" --cwd-file="$tmp"
          IFS= read -r -d ''' cwd < "$tmp"
          [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
          rm -f -- "$tmp"
        }
      '';
    };
}
