{
  ...
}:
{
  # Niri appearance configuration (layout, colors, window rules)

  flake.modules.homeManager.niri-appearance = {
    programs.niri.settings = {
      # Layout settings
      layout = {
        gaps = 4;
        center-focused-column = "never";

        # Transparent background for DMS wallpaper integration
        background-color = "transparent";

        # Default column width
        default-column-width = {
          proportion = 0.9;
        };

        # Preset column widths for cycling with Mod+R
        preset-column-widths = [
          { proportion = 0.9; }
          { proportion = 0.7; }
          { proportion = 0.5; }
          { proportion = 0.3; }
          { proportion = 0.5; }
          { proportion = 0.7; }
          { proportion = 0.9; }
          { proportion = 1.0; }
        ];

        # Preset window heights for cycling with Mod+Shift+R
        preset-window-heights = [
          { proportion = 0.7; }
          { proportion = 0.5; }
          { proportion = 0.3; }
          { proportion = 0.5; }
          { proportion = 0.7; }
          { proportion = 1.0; }
        ];

        # Focus ring - Catppuccin-style colors
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#74c7ec";
          inactive.color = "#6c7086";
        };

        # Border
        border = {
          enable = false;
          width = 2;
          active.color = "#74c7ec";
          inactive.color = "#6c7086";
        };

        # Shadow
        shadow = {
          enable = true;
          draw-behind-window = true;
          softness = 30;
          spread = 5;
          offset = {
            x = 0;
            y = 5;
          };
          color = "#00000070";
        };

        # Tab indicator colors
        tab-indicator = {
          active.color = "#74c7ec";
          inactive.color = "#6c7086";
        };

        # Insert hint
        insert-hint.display.color = "#74c7ec80";
      };

      # Hotkey overlay
      hotkey-overlay = {
        skip-at-startup = true;
      };

      # Screenshot path
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      # Animations
      animations = {
        slowdown = 0.75;
      };

      # Window rules
      window-rules = [
        # Work around WezTerm's initial configure bug
        {
          matches = [ { app-id = "^org\\.wezfurlong\\.wezterm$"; } ];
          default-column-width = { };
        }
        # Open Firefox picture-in-picture as floating
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        # Global window rule: rounded corners, tiled state, no border background
        {
          geometry-corner-radius = {
            top-left = 12.0;
            top-right = 12.0;
            bottom-left = 12.0;
            bottom-right = 12.0;
          };
          clip-to-geometry = true;
          draw-border-with-background = false;
        }
      ];

      # Layer rules for DMS wallpaper blur
      layer-rules = [
        {
          matches = [ { namespace = "dms:blurwallpaper"; } ];
          place-within-backdrop = true;
        }
      ];
    };
  };
}
