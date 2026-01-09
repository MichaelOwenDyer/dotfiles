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
        settings = {
          yazi = {
            ratio = [
              1
              4
              3
            ];
            sort_by = "natural";
            sort_sensitive = true;
            sort_reverse = false;
            sort_dir_first = true;
            linemode = "none";
            show_hidden = true;
            show_symlink = true;
          };

          preview = {
            image_filter = "lanczos3";
            image_quality = 90;
            tab_size = 1;
            max_width = 600;
            max_height = 900;
            cache_dir = "";
            ueberzug_scale = 1;
            ueberzug_offset = [
              0
              0
              0
              0
            ];
          };

          tasks = {
            micro_workers = 5;
            macro_workers = 10;
            bizarre_retry = 5;
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
      # Enable EXIF tool
      home.packages = with pkgs; [
        exiftool
      ];
    };
}
