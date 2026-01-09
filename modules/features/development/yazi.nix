{
  ...
}:
{
  flake.modules.homeManager.yazi =
    {
      pkgs,
      ...
    }:
    {
      programs.yazi = {
        enable = true;
        plugins = {
          # TODO: Add keymaps for these plugins
          inherit (pkgs.yaziPlugins) git sudo ouch diff gitui compress;
        };
        flavors = {
          inherit (pkgs.yaziPlugins) nord;
        };
        settings = {
          mgr = {
            show_hidden = true;
            show_symlink = true;
            sort_dir_first = true;
          };
          # TODO: Open text files in yazi using helix editor
#          opener = {
#            edit = [{ run = "hx $s"; block = true; }];
#          };
#          open = {
#            prepend_rules = [{ mime = "text/plain"; use = "edit"; }];
#          };
        };
      };
      xdg.configFile."yazi/theme.toml".text = ''
        [flavor]
        light = "nord"
        dark = "nord"
      '';
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
      # Enable EXIF tool
      home.packages = with pkgs; [
        exiftool
      ];
    };
}
