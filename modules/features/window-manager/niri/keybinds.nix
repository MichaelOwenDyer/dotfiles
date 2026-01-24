{
  ...
}:
{
  # Niri keybindings configuration
  # Unified modifier hierarchy:
  #   Mod        = Focus
  #   Mod+Ctrl   = Move
  #   Mod+Shift  = Workspace scope
  #   Mod+Alt    = Monitor/Display scope

  flake.modules.homeManager.niri-keybinds =
    { pkgs, ... }:
    let
      # DMS is in PATH via home.packages when dank-material-shell is enabled
      dms = cmd: args: {
        action.spawn = [ "dms" "ipc" "call" cmd ] ++ args;
      };
      dms' = cmd: args: extraAttrs: (dms cmd args) // extraAttrs;
    in
    {
      programs.niri.settings.binds = {
        # ====================
        # Hotkey overlay
        # ====================
        "Mod+Shift+Slash".action.show-hotkey-overlay = [ ];

        # ====================
        # DMS Shell Integration
        # ====================

        # Application launcher
        "Mod+Space" = dms "spotlight" [ "toggle" ];

        # Clipboard manager
        "Mod+V" = dms "clipboard" [ "toggle" ];

        # Notification center
        "Mod+N" = dms "notifications" [ "toggle" ];

        # Process list / task manager
        "Mod+M" = dms "processlist" [ "focusOrToggle" ];

        # Settings
        "Mod+Comma" = dms "settings" [ "focusOrToggle" ];

        # Power menu
        "Mod+X" = dms "powermenu" [ "toggle" ];

        # Notepad
        "Mod+P" = dms "notepad" [ "toggle" ];

        # Wallpaper browser
        "Mod+Y" = dms "dankdash" [ "wallpaper" ];

        # Lock screen (standard Linux keybind)
        "Ctrl+Alt+L" = dms "lock" [ "lock" ];

        # Night mode toggle
        "Mod+Alt+N" = dms' "night" [ "toggle" ] { allow-when-locked = true; };

        # ====================
        # Audio controls (DMS IPC)
        # ====================
        "XF86AudioRaiseVolume" = dms' "audio" [ "increment" "3" ] { allow-when-locked = true; };
        "XF86AudioLowerVolume" = dms' "audio" [ "decrement" "3" ] { allow-when-locked = true; };
        "XF86AudioMute" = dms' "audio" [ "mute" ] { allow-when-locked = true; };
        "XF86AudioMicMute" = dms' "audio" [ "micmute" ] { allow-when-locked = true; };

        # ====================
        # Brightness controls (DMS IPC)
        # ====================
        "XF86MonBrightnessUp" = dms' "brightness" [ "increment" "5" "" ] { allow-when-locked = true; };
        "XF86MonBrightnessDown" = dms' "brightness" [ "decrement" "5" "" ] { allow-when-locked = true; };

        # ====================
        # Media controls
        # ====================
        "XF86AudioPlay" = dms' "mpris" [ "playPause" ] { allow-when-locked = true; };
        "XF86AudioStop" = dms' "mpris" [ "stop" ] { allow-when-locked = true; };
        "XF86AudioPrev" = dms' "mpris" [ "previous" ] { allow-when-locked = true; };
        "XF86AudioNext" = dms' "mpris" [ "next" ] { allow-when-locked = true; };

        # ====================
        # Screenshots (DMS IPC for niri 25.11+)
        # ====================
        "Print" = dms "niri" [ "screenshot" ];
        "Ctrl+Print" = dms "niri" [ "screenshotScreen" ];
        "Alt+Print" = dms "niri" [ "screenshotWindow" ];

        # ====================
        # Application launchers
        # ====================
        "Mod+T".action.spawn = "${pkgs.ghostty}/bin/ghostty";

        # ====================
        # Window management
        # ====================
        "Mod+Q" = {
          repeat = false;
          action.close-window = [ ];
        };

        # Overview
        "Mod+O" = {
          repeat = false;
          action.toggle-overview = [ ];
        };

        # ====================
        # Focus navigation (Mod = Focus)
        # Within workspace: H/L = columns, J/K = windows in column
        # ====================
        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Down".action.focus-window-down = [ ];
        "Mod+Up".action.focus-window-up = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+H".action.focus-column-left = [ ];
        "Mod+J".action.focus-window-down = [ ];
        "Mod+K".action.focus-window-up = [ ];
        "Mod+L".action.focus-column-right = [ ];

        # Focus first/last column
        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];

        # ====================
        # Move windows (Mod+Ctrl = Move)
        # Within workspace
        # ====================
        "Mod+Ctrl+Left".action.move-column-left = [ ];
        "Mod+Ctrl+Down".action.move-window-down = [ ];
        "Mod+Ctrl+Up".action.move-window-up = [ ];
        "Mod+Ctrl+Right".action.move-column-right = [ ];
        "Mod+Ctrl+H".action.move-column-left = [ ];
        "Mod+Ctrl+J".action.move-window-down = [ ];
        "Mod+Ctrl+K".action.move-window-up = [ ];
        "Mod+Ctrl+L".action.move-column-right = [ ];

        # Move to first/last
        "Mod+Ctrl+Home".action.move-column-to-first = [ ];
        "Mod+Ctrl+End".action.move-column-to-last = [ ];

        # ====================
        # Workspace navigation (Mod+Shift = Workspace scope)
        # J/K for up/down in workspace stack
        # ====================
        "Mod+Shift+Down".action.focus-workspace-down = [ ];
        "Mod+Shift+Up".action.focus-workspace-up = [ ];
        "Mod+Shift+J".action.focus-workspace-down = [ ];
        "Mod+Shift+K".action.focus-workspace-up = [ ];

        # Move column to workspace (Mod+Shift+Ctrl)
        "Mod+Shift+Ctrl+Down".action.move-column-to-workspace-down = [ ];
        "Mod+Shift+Ctrl+Up".action.move-column-to-workspace-up = [ ];
        "Mod+Shift+Ctrl+J".action.move-column-to-workspace-down = [ ];
        "Mod+Shift+Ctrl+K".action.move-column-to-workspace-up = [ ];

        # Reorder workspace position in stack (Mod+Shift+Ctrl+H/L)
        "Mod+Shift+Ctrl+Left".action.move-workspace-up = [ ];
        "Mod+Shift+Ctrl+Right".action.move-workspace-down = [ ];
        "Mod+Shift+Ctrl+H".action.move-workspace-up = [ ];
        "Mod+Shift+Ctrl+L".action.move-workspace-down = [ ];

        # ====================
        # Monitor navigation (Mod+Alt = Monitor scope)
        # ====================
        "Mod+Alt+Left".action.focus-monitor-left = [ ];
        "Mod+Alt+Down".action.focus-monitor-down = [ ];
        "Mod+Alt+Up".action.focus-monitor-up = [ ];
        "Mod+Alt+Right".action.focus-monitor-right = [ ];
        "Mod+Alt+H".action.focus-monitor-left = [ ];
        "Mod+Alt+J".action.focus-monitor-down = [ ];
        "Mod+Alt+K".action.focus-monitor-up = [ ];
        "Mod+Alt+L".action.focus-monitor-right = [ ];

        # Move column to monitor (Mod+Alt+Ctrl)
        "Mod+Alt+Ctrl+Left".action.move-column-to-monitor-left = [ ];
        "Mod+Alt+Ctrl+Down".action.move-column-to-monitor-down = [ ];
        "Mod+Alt+Ctrl+Up".action.move-column-to-monitor-up = [ ];
        "Mod+Alt+Ctrl+Right".action.move-column-to-monitor-right = [ ];
        "Mod+Alt+Ctrl+H".action.move-column-to-monitor-left = [ ];
        "Mod+Alt+Ctrl+J".action.move-column-to-monitor-down = [ ];
        "Mod+Alt+Ctrl+K".action.move-column-to-monitor-up = [ ];
        "Mod+Alt+Ctrl+L".action.move-column-to-monitor-right = [ ];

        # ====================
        # Move workspace to monitor (Mod+Alt+Shift+Ctrl)
        # ====================
        "Mod+Alt+Shift+Ctrl+Left".action.move-workspace-to-monitor-left = [ ];
        "Mod+Alt+Shift+Ctrl+Down".action.move-workspace-to-monitor-down = [ ];
        "Mod+Alt+Shift+Ctrl+Up".action.move-workspace-to-monitor-up = [ ];
        "Mod+Alt+Shift+Ctrl+Right".action.move-workspace-to-monitor-right = [ ];
        "Mod+Alt+Shift+Ctrl+H".action.move-workspace-to-monitor-left = [ ];
        "Mod+Alt+Shift+Ctrl+J".action.move-workspace-to-monitor-down = [ ];
        "Mod+Alt+Shift+Ctrl+K".action.move-workspace-to-monitor-up = [ ];
        "Mod+Alt+Shift+Ctrl+L".action.move-workspace-to-monitor-right = [ ];

        # ====================
        # Mouse wheel navigation
        # ====================

        # Workspace with scroll (Mod+Shift)
        "Mod+Shift+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = [ ];
        };
        "Mod+Shift+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = [ ];
        };
        "Mod+Shift+Ctrl+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = [ ];
        };
        "Mod+Shift+Ctrl+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = [ ];
        };

        # Column navigation with scroll (Mod)
        "Mod+WheelScrollRight".action.focus-column-right = [ ];
        "Mod+WheelScrollLeft".action.focus-column-left = [ ];
        "Mod+Ctrl+WheelScrollRight".action.move-column-right = [ ];
        "Mod+Ctrl+WheelScrollLeft".action.move-column-left = [ ];

        # ====================
        # Workspace by index
        # ====================
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

        # ====================
        # Column management
        # ====================
        "Mod+BracketLeft".action.consume-or-expel-window-left = [ ];
        "Mod+BracketRight".action.consume-or-expel-window-right = [ ];

        # ====================
        # Window sizing
        # ====================
        "Mod+R".action.switch-preset-column-width = [ ];
        "Mod+Shift+R".action.switch-preset-window-height = [ ];
        "Mod+Ctrl+R".action.reset-window-height = [ ];
        "Mod+F".action.maximize-column = [ ];
        "Mod+Shift+F".action.fullscreen-window = [ ];
        "Mod+Ctrl+F".action.expand-column-to-available-width = [ ];

        # Centering
        "Mod+C".action.center-column = [ ];

        # Fine width/height adjustments
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Mod+Shift+Minus".action.set-window-height = "-10%";
        "Mod+Shift+Equal".action.set-window-height = "+10%";

        # ====================
        # Floating windows
        # ====================
        "Mod+Shift+V".action.toggle-window-floating = [ ];
        "Mod+Shift+Space".action.switch-focus-between-floating-and-tiling = [ ];

        # ====================
        # Tabbed columns
        # ====================
        "Mod+W".action.toggle-column-tabbed-display = [ ];

        # ====================
        # Keyboard shortcuts inhibit toggle
        # ====================
        "Mod+Escape" = {
          allow-inhibiting = false;
          action.toggle-keyboard-shortcuts-inhibit = [ ];
        };

        # ====================
        # Session
        # ====================
        "Mod+Shift+E".action.quit = [ ];
        "Ctrl+Alt+Delete".action.quit = [ ];

        # Power off monitors
        "Mod+Shift+P".action.power-off-monitors = [ ];
      };
    };
}
