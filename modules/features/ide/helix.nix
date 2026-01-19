{
  ...
}:
{
  # Helix editor with LSP support

  flake.modules.nixos.ide-helix =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.helix ];
    };

  flake.modules.darwin.ide-helix =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.helix ];
    };

  flake.modules.homeManager.ide-helix =
    { lib, pkgs, ... }:
    {
      # Set EDITOR for graphical sessions via systemd
      systemd.user.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };

      programs.helix = {
        enable = true;
        defaultEditor = true;

        extraPackages = with pkgs; [
          # Web
          typescript-language-server
          vscode-langservers-extracted # HTML, CSS, JSON, ESLint
          tailwindcss-language-server
          nodePackages.prettier

          # Systems
          rust-analyzer
          clang-tools # clangd

          # JVM
          java-language-server

          # Config formats
          yaml-language-server
          taplo # TOML

          # Shell/Ops
          bash-language-server
          docker-language-server
          terraform-ls

          # Nix
          nil
          nixfmt-rfc-style

          # Markdown
          marksman
          markdown-oxide
        ];

        settings = {
          theme = "catppuccin_mocha";

          editor = {
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };
            line-number = "relative";
            cursorline = true;
            color-modes = true;
            auto-pairs = true;
            auto-info = true;
            soft-wrap.enable = true;

            lsp = {
              display-messages = true;
              display-inlay-hints = true;
            };

            whitespace.render = {
              space = "none";
              tab = "all";
              newline = "none";
              nbsp = "all";
            };

            indent-guides = {
              render = true;
              character = "│";
            };

            file-picker = {
              hidden = false;
              git-ignore = true;
            };

            statusline = {
              left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
              center = [ "diagnostics" ];
              right = [ "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
            };

            auto-save = {
              focus-lost = true;
              after-delay.enable = false;
            };
          };

          keys.normal = {
            esc = [ "collapse_selection" "keep_primary_selection" ];

            # Space leader
            space = {
              q = ":q";
              Q = ":q!";
              w = ":w";
              W = ":w!";
              space = "file_picker";
              f = "file_picker";
              b = "buffer_picker";
              "/" = "global_search";
              v = "vsplit";
              s = "hsplit";

              # LSP
              l = {
                a = "code_action";
                r = "rename_symbol";
                f = ":format";
                d = "goto_definition";
                D = "goto_declaration";
                i = "goto_implementation";
                t = "goto_type_definition";
                R = "goto_reference";
              };

              # Diagnostics
              d = {
                d = "goto_next_diag";
                D = "goto_prev_diag";
                l = "diagnostics_picker";
              };
            };

            g = {
              d = "goto_definition";
              r = "goto_reference";
              i = "goto_implementation";
            };

            # Center screen after jumps
            "C-d" = [ "half_page_down" "align_view_center" ];
            "C-u" = [ "half_page_up" "align_view_center" ];
            n = [ "search_next" "align_view_center" ];
            N = [ "search_prev" "align_view_center" ];
          };

          keys.insert = {
            j = { k = "normal_mode"; }; # jk to escape
          };
        };

        languages.language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          }
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "typescript";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [ "--parser" "typescript" ];
            };
          }
          {
            name = "javascript";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [ "--parser" "javascript" ];
            };
          }
          {
            name = "json";
            auto-format = true;
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [ "--parser" "json" ];
            };
          }
          {
            name = "markdown";
            auto-format = true;
            soft-wrap.enable = true;
            formatter = {
              command = lib.getExe pkgs.nodePackages.prettier;
              args = [ "--parser" "markdown" ];
            };
          }
          {
            name = "toml";
            auto-format = true;
            formatter.command = lib.getExe pkgs.taplo;
          }
        ];
      };
    };
}
