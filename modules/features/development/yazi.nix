{
  ...
}:
let
  yazi = {
    programs.yazi = {
      enable = true;
      settings = {
        mgr = {
          show_hidden = true;
          show_symlink = true;
          sort_dir_first = true;
        };
      };
    };
  };
in
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
    (
      yazi
      // {
        programs.yazi.settings = {
          plugins = {
            # TODO: Add keymaps for these plugins
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
      }
    );
}
