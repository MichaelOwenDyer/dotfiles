{
  ...
}:
{
  # Helix editor configuration - modal editor with batteries included

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
      # Set EDITOR/VISUAL in systemd user session (propagates to graphical sessions)
      systemd.user.sessionVariables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };

      programs.helix = {
        enable = true;

        # Language servers for IDE-like features
        # Benefit: Autocomplete, diagnostics, go-to-definition, etc.
        extraPackages = with pkgs; [
          # Web/JS/TS
          typescript-language-server
          vscode-langservers-extracted # HTML, CSS, JSON, ESLint
          tailwindcss-language-server
          nodePackages.prettier

          # Systems
          rust-analyzer
          clang-tools # C/C++ (clangd)

          # JVM
          java-language-server

          # Config/Data
          yaml-language-server
          taplo # TOML

          # Shell/Ops
          bash-language-server
          docker-language-server
          terraform-ls

          # Nix
          nil # Nix LSP
          nixfmt-rfc-style # Formatter

          # Markdown
          marksman
          markdown-oxide
        ];

        defaultEditor = true;

        settings = {
          theme = "catppuccin_mocha";

          editor = {
            # Cursor shapes for mode indication
            # Benefit: Visual feedback on current mode without looking at statusline
            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };

            # Relative line numbers for easy vim motions (5j, 10k, etc.)
            # Benefit: Jump to visible lines without counting
            line-number = "relative";

            # Show LSP messages inline
            lsp.display-messages = true;

            # Show inlay hints (type annotations, parameter names)
            # Benefit: See types without hovering
            lsp.display-inlay-hints = true;

            # Highlight current line
            # Benefit: Easy to track cursor position
            cursorline = true;

            # Show color swatches for color codes
            # Benefit: Visual preview of colors in CSS/config files
            color-modes = true;

            # Render whitespace characters
            # Benefit: Catch trailing whitespace, mixed tabs/spaces
            whitespace.render = {
              space = "none";
              tab = "all";
              newline = "none";
              nbsp = "all";
            };

            # Soft wrap long lines
            # Benefit: No horizontal scrolling for prose/markdown
            soft-wrap.enable = true;

            # Indent guides
            # Benefit: Visual alignment for nested code
            indent-guides = {
              render = true;
              character = "│";
            };

            # File picker settings
            file-picker = {
              hidden = false; # Show hidden files
              git-ignore = true; # Respect .gitignore
            };

            # Statusline customization
            statusline = {
              left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
              center = [ "diagnostics" ];
              right = [ "selections" "position" "file-encoding" "file-line-ending" "file-type" ];
            };

            # Auto-save when focus is lost
            # Benefit: Never lose work when switching windows
            auto-save = {
              focus-lost = true;
              after-delay.enable = false;
            };

            # Smarter auto-pairs
            auto-pairs = true;

            # Show completion docs automatically
            auto-info = true;
          };

          keys.normal = {
            # Clear selection on escape
            esc = [ "collapse_selection" "keep_primary_selection" ];

            # Space as leader key (like Neovim/Doom Emacs)
            space = {
              q = ":q";
              Q = ":q!";
              space = "file_picker";
              w = ":w";
              W = ":w!";
              f = "file_picker";
              b = "buffer_picker";
              "/" = "global_search";

              # Window management
              "v" = "vsplit";
              "s" = "hsplit";

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

            # Quick navigation
            "g" = {
              "d" = "goto_definition";
              "r" = "goto_reference";
              "i" = "goto_implementation";
            };

            # Center screen after jumps
            "C-d" = [ "half_page_down" "align_view_center" ];
            "C-u" = [ "half_page_up" "align_view_center" ];
            "n" = [ "search_next" "align_view_center" ];
            "N" = [ "search_prev" "align_view_center" ];
          };

          keys.insert = {
            # Quick escape to normal mode
            "j" = { "k" = "normal_mode"; };
          };
        };

        languages = {
          language = [
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
              formatter = {
                command = lib.getExe pkgs.nodePackages.prettier;
                args = [ "--parser" "markdown" ];
              };
              soft-wrap.enable = true;
            }
            {
              name = "toml";
              auto-format = true;
              formatter.command = lib.getExe pkgs.taplo;
            }
          ];
        };
      };
    };
}
