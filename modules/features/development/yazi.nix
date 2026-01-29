{
  lib,
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
    { config, pkgs, ... }:
    let
      cfg = config.programs.yazi;

      # Local plugin source
      impermanencePlugin = ./yazi-impermanence;
    in
    {
      options.programs.yazi.impermanence = {
        enable = lib.mkEnableOption "yazi impermanence plugin";

        marker = lib.mkOption {
          type = lib.types.str;
          default = " 💾";
          description = "Marker shown for persisted items";
        };

        ephemeralMarker = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Marker shown for ephemeral items (empty = don't show)";
        };

        color = lib.mkOption {
          type = lib.types.str;
          default = "#83a598";
          description = "Color for persisted marker (gruvbox aqua)";
        };

        ephemeralColor = lib.mkOption {
          type = lib.types.str;
          default = "#cc241d";
          description = "Color for ephemeral marker (gruvbox red)";
        };

        showHeader = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show persistence indicator in header";
        };

        showLinemode = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Show persistence indicator per file";
        };
      };

      config = {
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
          initLua =
            ''
              require("git"):setup()
            ''
            + lib.optionalString cfg.impermanence.enable ''
              -- Setup impermanence plugin to show persistence status
              require("impermanence"):setup({
                marker = "${cfg.impermanence.marker}",
                ephemeral_marker = "${cfg.impermanence.ephemeralMarker}",
                color = "${cfg.impermanence.color}",
                ephemeral_color = "${cfg.impermanence.ephemeralColor}",
                show_header = ${lib.boolToString cfg.impermanence.showHeader},
                show_linemode = ${lib.boolToString cfg.impermanence.showLinemode},
                header_order = 500,
                linemode_order = 500,
              })
            '';
          plugins =
            {
              inherit (pkgs.yaziPlugins)
                git
                sudo
                ouch
                diff
                gitui
                compress
                ;
            }
            // lib.optionalAttrs cfg.impermanence.enable { impermanence = impermanencePlugin; };
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
    };
}
