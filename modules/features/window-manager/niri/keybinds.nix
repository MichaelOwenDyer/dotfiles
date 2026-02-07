{
  ...
}:
{
  # Niri keybindings configuration
  # Unified modifier hierarchy:
  #   Mod        = Focus (seamless window/workspace)
  #   Ctrl+Mod   = Move (seamless window/workspace)
  #   Mod+Alt    = Workspace scope
  #   Shift+Mod  = Monitor scope

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
        "Shift+Mod+Slash".action.show-hotkey-overlay = [ ];

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
        # H/L = columns, J/K = seamless window/workspace navigation
        # ====================
        "Mod+Left".action.focus-column-left = [ ];
        "Mod+Down".action.focus-window-or-workspace-down = [ ];
        "Mod+Up".action.focus-window-or-workspace-up = [ ];
        "Mod+Right".action.focus-column-right = [ ];
        "Mod+H".action.focus-column-left = [ ];
        "Mod+J".action.focus-window-or-workspace-down = [ ];
        "Mod+K".action.focus-window-or-workspace-up = [ ];
        "Mod+L".action.focus-column-right = [ ];

        # Focus first/last column
        "Mod+Home".action.focus-column-first = [ ];
        "Mod+End".action.focus-column-last = [ ];

        # ====================
        # Move windows (Ctrl+Mod = Move)
        # J/K = seamless window/workspace movement
        # ====================
        "Ctrl+Mod+Left".action.move-column-left = [ ];
        "Ctrl+Mod+Down".action.move-window-down-or-to-workspace-down = [ ];
        "Ctrl+Mod+Up".action.move-window-up-or-to-workspace-up = [ ];
        "Ctrl+Mod+Right".action.move-column-right = [ ];
        "Ctrl+Mod+H".action.move-column-left = [ ];
        "Ctrl+Mod+J".action.move-window-down-or-to-workspace-down = [ ];
        "Ctrl+Mod+K".action.move-window-up-or-to-workspace-up = [ ];
        "Ctrl+Mod+L".action.move-column-right = [ ];

        # Move to first/last
        "Ctrl+Mod+Home".action.move-column-to-first = [ ];
        "Ctrl+Mod+End".action.move-column-to-last = [ ];

        # ====================
        # Workspace navigation (Mod+Alt = Workspace scope)
        # ====================
        "Mod+Alt+Down".action.focus-workspace-down = [ ];
        "Mod+Alt+Up".action.focus-workspace-up = [ ];
        "Mod+Alt+J".action.focus-workspace-down = [ ];
        "Mod+Alt+K".action.focus-workspace-up = [ ];

        # Move column to workspace (Ctrl+Mod+Alt)
        "Ctrl+Mod+Alt+Down".action.move-column-to-workspace-down = [ ];
        "Ctrl+Mod+Alt+Up".action.move-column-to-workspace-up = [ ];
        "Ctrl+Mod+Alt+J".action.move-column-to-workspace-down = [ ];
        "Ctrl+Mod+Alt+K".action.move-column-to-workspace-up = [ ];

        # Reorder workspace position in stack (Ctrl+Mod+Alt+H/L)
        "Ctrl+Mod+Alt+Left".action.move-workspace-up = [ ];
        "Ctrl+Mod+Alt+Right".action.move-workspace-down = [ ];
        "Ctrl+Mod+Alt+H".action.move-workspace-up = [ ];
        "Ctrl+Mod+Alt+L".action.move-workspace-down = [ ];

        # ====================
        # Monitor navigation (Shift+Mod = Monitor scope)
        # ====================
        "Shift+Mod+Left".action.focus-monitor-left = [ ];
        "Shift+Mod+Down".action.focus-monitor-down = [ ];
        "Shift+Mod+Up".action.focus-monitor-up = [ ];
        "Shift+Mod+Right".action.focus-monitor-right = [ ];
        "Shift+Mod+H".action.focus-monitor-left = [ ];
        "Shift+Mod+J".action.focus-monitor-down = [ ];
        "Shift+Mod+K".action.focus-monitor-up = [ ];
        "Shift+Mod+L".action.focus-monitor-right = [ ];

        # Move column to monitor (Ctrl+Shift+Mod)
        "Ctrl+Shift+Mod+Left".action.move-column-to-monitor-left = [ ];
        "Ctrl+Shift+Mod+Down".action.move-column-to-monitor-down = [ ];
        "Ctrl+Shift+Mod+Up".action.move-column-to-monitor-up = [ ];
        "Ctrl+Shift+Mod+Right".action.move-column-to-monitor-right = [ ];
        "Ctrl+Shift+Mod+H".action.move-column-to-monitor-left = [ ];
        "Ctrl+Shift+Mod+J".action.move-column-to-monitor-down = [ ];
        "Ctrl+Shift+Mod+K".action.move-column-to-monitor-up = [ ];
        "Ctrl+Shift+Mod+L".action.move-column-to-monitor-right = [ ];

        # ====================
        # Move workspace to monitor (Ctrl+Shift+Mod+Alt)
        # ====================
        "Ctrl+Shift+Mod+Alt+Left".action.move-workspace-to-monitor-left = [ ];
        "Ctrl+Shift+Mod+Alt+Down".action.move-workspace-to-monitor-down = [ ];
        "Ctrl+Shift+Mod+Alt+Up".action.move-workspace-to-monitor-up = [ ];
        "Ctrl+Shift+Mod+Alt+Right".action.move-workspace-to-monitor-right = [ ];
        "Ctrl+Shift+Mod+Alt+H".action.move-workspace-to-monitor-left = [ ];
        "Ctrl+Shift+Mod+Alt+J".action.move-workspace-to-monitor-down = [ ];
        "Ctrl+Shift+Mod+Alt+K".action.move-workspace-to-monitor-up = [ ];
        "Ctrl+Shift+Mod+Alt+L".action.move-workspace-to-monitor-right = [ ];

        # ====================
        # Mouse wheel navigation
        # ====================

        # Workspace with scroll (Mod+Alt)
        "Mod+Alt+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-workspace-down = [ ];
        };
        "Mod+Alt+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-workspace-up = [ ];
        };
        "Ctrl+Mod+Alt+WheelScrollDown" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-down = [ ];
        };
        "Ctrl+Mod+Alt+WheelScrollUp" = {
          cooldown-ms = 150;
          action.move-column-to-workspace-up = [ ];
        };

        # Monitor with scroll (Shift+Mod)
        "Shift+Mod+WheelScrollDown" = {
          cooldown-ms = 150;
          action.focus-monitor-down = [ ];
        };
        "Shift+Mod+WheelScrollUp" = {
          cooldown-ms = 150;
          action.focus-monitor-up = [ ];
        };
        "Shift+Mod+WheelScrollRight" = {
          cooldown-ms = 150;
          action.focus-monitor-right = [ ];
        };
        "Shift+Mod+WheelScrollLeft" = {
          cooldown-ms = 150;
          action.focus-monitor-left = [ ];
        };

        # Column navigation with scroll (Mod)
        "Mod+WheelScrollRight".action.focus-column-right = [ ];
        "Mod+WheelScrollLeft".action.focus-column-left = [ ];
        "Ctrl+Mod+WheelScrollRight".action.move-column-right = [ ];
        "Ctrl+Mod+WheelScrollLeft".action.move-column-left = [ ];

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
        "Ctrl+Mod+1".action.move-column-to-workspace = 1;
        "Ctrl+Mod+2".action.move-column-to-workspace = 2;
        "Ctrl+Mod+3".action.move-column-to-workspace = 3;
        "Ctrl+Mod+4".action.move-column-to-workspace = 4;
        "Ctrl+Mod+5".action.move-column-to-workspace = 5;
        "Ctrl+Mod+6".action.move-column-to-workspace = 6;
        "Ctrl+Mod+7".action.move-column-to-workspace = 7;
        "Ctrl+Mod+8".action.move-column-to-workspace = 8;
        "Ctrl+Mod+9".action.move-column-to-workspace = 9;

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
        "Shift+Mod+R".action.switch-preset-window-height = [ ];
        "Ctrl+Mod+R".action.reset-window-height = [ ];
        "Mod+F".action.maximize-column = [ ];
        "Shift+Mod+F".action.fullscreen-window = [ ];
        "Ctrl+Mod+F".action.expand-column-to-available-width = [ ];

        # Centering
        "Mod+C".action.center-column = [ ];

        # Fine width/height adjustments
        "Mod+Minus".action.set-column-width = "-10%";
        "Mod+Equal".action.set-column-width = "+10%";
        "Shift+Mod+Minus".action.set-window-height = "-10%";
        "Shift+Mod+Equal".action.set-window-height = "+10%";

        # ====================
        # Floating windows
        # ====================
        "Shift+Mod+V".action.toggle-window-floating = [ ];
        "Shift+Mod+Space".action.switch-focus-between-floating-and-tiling = [ ];

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
        "Shift+Mod+E".action.quit = [ ];
        "Ctrl+Alt+Delete".action.quit = [ ];

        # Power off monitors
        "Shift+Mod+P".action.power-off-monitors = [ ];

        # Wake monitors (power-off then simulate input to force HDMI re-handshake)
        # Useful for TVs that don't wake properly from DPMS
        "Ctrl+Shift+Mod+P".action.spawn = [
          "sh"
          "-c"
          "niri msg action power-off-monitors; sleep 0.5; wtype -k Escape"
        ];
      };
    };
}
