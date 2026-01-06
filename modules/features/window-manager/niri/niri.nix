{
  inputs,
  ...
}:
{
  # Niri scrolling window manager - NixOS module
  # Note: programs.niri.settings is a home-manager option, not NixOS
  # The niri-flake module auto-imports homeModules.config when home-manager is detected
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.self.modules.nixos.niri-module ];

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable; # Use unstable version - breakages expected
        # package = pkgs.niri-stable;
      };
    };

  # Niri scrolling window manager - Home Manager module (settings)
  flake.modules.homeManager.niri =
    { pkgs, ... }:
    {
      programs.niri.settings = {
        # Spawn commands at startup
        spawn-at-startup = [
          {
            argv = [
              "dbus-update-activation-environment"
              "--systemd"
              "WAYLAND_DISPLAY"
              "XDG_CURRENT_DESKTOP=niri"
              "XDG_SESSION_TYPE=wayland"
            ];
          }
          {
            argv = [
              "systemctl"
              "--user"
              "restart"
              "dms.service"
            ];
          }
        ];

        # Input configuration
        input = {
          keyboard = {
            numlock = true;
          };
          touchpad = {
            tap = true;
            drag = true;
            natural-scroll = true;
            accel-speed = 0.1;
            scroll-method = "two-finger";
            scroll-factor = {
              horizontal = 0.35;
              vertical = 0.35;
            };
          };
        };

        # Output configuration
        outputs = {
          "eDP-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 59.934;
            };
            scale = 1.15;
            position = {
              x = 0;
              y = 0;
            };
          };
        };

        # Layout settings
        layout = {
          # DMS uses gaps=4, original config had 5
          gaps = 4;
          center-focused-column = "never";

          # Transparent background for DMS wallpaper integration
          background-color = "transparent";

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
            { proportion = 0.5; }
            { proportion = 0.3; }
            { proportion = 0.5; }
            { proportion = 0.7; }
          ];

          # Default column width
          default-column-width = {
            proportion = 0.9;
          };

          # Focus ring - DMS theme colors (Catppuccin-style)
          focus-ring = {
            enable = true;
            width = 2; # DMS uses 2
            active.color = "#74c7ec";
            inactive.color = "#6c7086";
          };

          # Border (disabled in original, but DMS sets colors)
          border = {
            enable = false;
            width = 2; # DMS uses 2
            active.color = "#74c7ec";
            inactive.color = "#6c7086";
          };

          # Shadow - DMS theme
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

          # Tab indicator colors from DMS
          tab-indicator = {
            active.color = "#74c7ec";
            inactive.color = "#6c7086";
          };

          # Insert hint from DMS
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
          # DMS global window rule: rounded corners, tiled state, no border background
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

        # Keybinds
        binds = {
          # Hotkey overlay
          "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

          # Application launchers
          "Mod+T".action.spawn = "${pkgs.ghostty}/bin/ghostty";
          "Alt+Space".action.spawn = "${pkgs.fuzzel}/bin/fuzzel";
          "Super+Alt+L".action.spawn = "${pkgs.swaylock}/bin/swaylock";

          # Volume controls (wpctl is part of wireplumber)
          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          };
          "Mod+XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0";
          }; # Alt for broken F3
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            repeat = false;
            action.spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "Mod+XF86AudioMute" = {
            allow-when-locked = true;
            repeat = false;
            action.spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          }; # Alt mic mute
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            repeat = false;
            action.spawn-sh = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          };

          # Media controls
          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.playerctl}/bin/playerctl play-pause";
          };
          "XF86AudioStop" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.playerctl}/bin/playerctl stop";
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.playerctl}/bin/playerctl previous";
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn-sh = "${pkgs.playerctl}/bin/playerctl next";
          };

          # Brightness controls
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn = [
              "${pkgs.brightnessctl}/bin/brightnessctl"
              "--class=backlight"
              "set"
              "+10%"
            ];
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn = [
              "${pkgs.brightnessctl}/bin/brightnessctl"
              "--class=backlight"
              "set"
              "10%-"
            ];
          };

          # Overview
          "Mod+O" = {
            repeat = false;
            action.toggle-overview = [ ];
          };

          # Window management
          "Mod+Q" = {
            repeat = false;
            action.close-window = [ ];
          };

          # Focus navigation (arrow keys and vim keys)
          "Mod+Left".action.focus-column-left = [ ];
          "Mod+Down".action.focus-window-down = [ ];
          "Mod+Up".action.focus-window-up = [ ];
          "Mod+Right".action.focus-column-right = [ ];
          "Mod+H".action.focus-column-left = [ ];
          "Mod+J".action.focus-window-down = [ ];
          "Mod+K".action.focus-window-up = [ ];
          "Mod+L".action.focus-column-right = [ ];

          # Move windows (arrow keys and vim keys)
          "Mod+Ctrl+Left".action.move-column-left = [ ];
          "Mod+Ctrl+Down".action.move-window-down = [ ];
          "Mod+Ctrl+Up".action.move-window-up = [ ];
          "Mod+Ctrl+Right".action.move-column-right = [ ];
          "Mod+Ctrl+H".action.move-column-left = [ ];
          "Mod+Ctrl+J".action.move-window-down = [ ];
          "Mod+Ctrl+K".action.move-window-up = [ ];
          "Mod+Ctrl+L".action.move-column-right = [ ];

          # Focus first/last column
          "Mod+Home".action.focus-column-first = [ ];
          "Mod+End".action.focus-column-last = [ ];
          "Mod+Ctrl+Home".action.move-column-to-first = [ ];
          "Mod+Ctrl+End".action.move-column-to-last = [ ];

          # Monitor focus (arrow keys and vim keys)
          "Mod+Shift+Left".action.focus-monitor-left = [ ];
          "Mod+Shift+Down".action.focus-monitor-down = [ ];
          "Mod+Shift+Up".action.focus-monitor-up = [ ];
          "Mod+Shift+Right".action.focus-monitor-right = [ ];
          "Mod+Shift+H".action.focus-monitor-left = [ ];
          "Mod+Shift+J".action.focus-monitor-down = [ ];
          "Mod+Shift+K".action.focus-monitor-up = [ ];
          "Mod+Shift+L".action.focus-monitor-right = [ ];

          # Move columns to monitor
          "Mod+Shift+Ctrl+Left".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+Down".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+Up".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+Right".action.move-column-to-monitor-right = [ ];
          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = [ ];
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = [ ];
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = [ ];
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = [ ];

          # Workspace navigation
          "Mod+Page_Down".action.focus-workspace-down = [ ];
          "Mod+Page_Up".action.focus-workspace-up = [ ];
          "Mod+U".action.focus-workspace-down = [ ];
          "Mod+I".action.focus-workspace-up = [ ];
          "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [ ];
          "Mod+Ctrl+U".action.move-column-to-workspace-down = [ ];
          "Mod+Ctrl+I".action.move-column-to-workspace-up = [ ];

          # Move workspace
          "Mod+Shift+Page_Down".action.move-workspace-down = [ ];
          "Mod+Shift+Page_Up".action.move-workspace-up = [ ];
          "Mod+Shift+U".action.move-workspace-down = [ ];
          "Mod+Shift+I".action.move-workspace-up = [ ];

          # Mouse wheel workspace navigation
          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = [ ];
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = [ ];
          };
          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-down = [ ];
          };
          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-up = [ ];
          };

          # Mouse wheel column navigation
          "Mod+WheelScrollRight".action.focus-column-right = [ ];
          "Mod+WheelScrollLeft".action.focus-column-left = [ ];
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];

          # Shift+wheel for horizontal scrolling
          "Mod+Shift+WheelScrollDown".action.focus-column-right = [ ];
          "Mod+Shift+WheelScrollUp".action.focus-column-left = [ ];
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = [ ];
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = [ ];

          # Workspace by index
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;

          # Previous workspace
          "Mod+Tab".action.focus-workspace-previous = [ ];

          # Column management
          "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
          "Mod+BracketRight".action.consume-or-expel-window-right = [ ];
          "Mod+Comma".action.consume-window-into-column = [ ];
          "Mod+Period".action.expel-window-from-column = [ ];

          # Window sizing
          "Mod+R".action.switch-preset-column-width = [ ];
          "Mod+Shift+R".action.switch-preset-window-height = [ ];
          "Mod+Ctrl+R".action.reset-window-height = [ ];
          "Mod+F".action.maximize-column = [ ];
          "Mod+Shift+F".action.fullscreen-window = [ ];
          "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];

          # Centering
          "Mod+C".action.center-column = [ ];
          "Mod+Ctrl+C".action.center-visible-columns = [ ];

          # Fine width/height adjustments
          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          # Floating windows
          "Mod+V".action.toggle-window-floating = [ ];
          "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];

          # Tabbed columns
          "Mod+W".action.toggle-column-tabbed-display = [ ];

          # Screenshots
          "Print".action.screenshot = [ ];
          "Ctrl+Print".action.screenshot-screen = [ ];
          "Alt+Print".action.screenshot-window = [ ];

          # Keyboard shortcuts inhibit toggle
          "Mod+Escape" = {
            allow-inhibiting = false;
            action.toggle-keyboard-shortcuts-inhibit = [ ];
          };

          # Quit
          "Mod+Shift+E".action.quit = [ ];
          "Ctrl+Alt+Delete".action.quit = [ ];

          # Power off monitors
          "Mod+Shift+P".action.power-off-monitors = [ ];
        };
      };
    };
}
