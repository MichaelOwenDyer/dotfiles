{
  pkgs,
  config,
  ...
}:

{
  imports = [
    ./waybar.nix
  ];

  # Use NixOS module to create a desktop session entry
  config.programs.hyprland.enable = true;

  config.home-manager.users.michael = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      package = null; # Set this to null because we are using the NixOS module to install Hyprland
      settings = {
        "$mod" = "SUPER";
        debug.disable_logs = false;
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            disable_while_typing = true;
          };
        };
        general = {
          gaps_in = 5;
          gaps_out = 8;
          border_size = 2;
          layout = "dwindle";
        };
        monitor = [
          "eDP-1,1920x1080@60,0x0,1"
        ];
        # Autostart applications
        exec-once = let wallpaper = ./background.jpg; in [
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP" # Essential
          "${pkgs.waybar}/bin/waybar"
          "${pkgs.swaybg}/bin/swaybg -i ${wallpaper} -f" # Ensure background.jpg is in the same dir
          "${pkgs.pamixer}/bin/pamixer --set-volume 50" # Set default sink volume
        ];

        # Use the $mod variable defined above
        bind = [
          "$mod, RETURN, exec, ${pkgs.alacritty}/bin/alacritty"
          "$mod, Q, killactive,"
          "$mod, M, exec, ${pkgs.wlogout}/bin/wlogout"
          "$mod, S, exec, ${pkgs.grimblast}/bin/grimblast copy area"
          "$mod, D, exec, ${pkgs.wofi}/bin/wofi --show drun"

          # Workspace navigation
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to a workspace
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Move active window to the next/previous workspace using lowercase key names
          "$mod, left, movetoworkspace, prev"
          "$mod, right, movetoworkspace, next"
          # Move active window to the next/previous monitor using lowercase key names
          # Note: Hyprland uses 'l', 'r', 'u', 'd' for directions with movetoworkspace,
          # 'prev' and 'next' are valid. 'prevmonitor' and 'nextmonitor' are not standard
          # parameters for movetoworkspace. You might mean 'movetoworkspace, m+1' or 'movetoworkspace, m-1'
          # or 'movewindow, mon:left' / 'movewindow, mon:right' if these are custom scripts or aliases.
          # For built-in, consider:
          "$mod SHIFT, left, movewindow, l" # Or use 'moveactivewindow, monitor:left' if that's what you intend.
                                                # The 'movetoworkspace, prevmonitor' isn't standard.
                                                # Let's assume you want to move window to monitor left/right
          "$mod SHIFT, right, movewindow, r" # similar to above.
                                                 # Standard for moving to monitor is more like:
                                                 # "$mod SHIFT, left, movewindow, mon:-1"
                                                 # "$mod SHIFT, right, movewindow, mon:+1"

          # Move focus with keyboard (h,j,k,l are fine as they are characters)
          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          # Media keys
          ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"
          ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer --decrease 5"
          ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer --increase 5"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86Search, exec, ${pkgs.wofi}/bin/wofi --show run"
        ];

        # Environment variables are usually better handled by home.sessionVariables
        # or home.pointerCursor for cursor themes.
        # env = []; # Keep this empty or remove if not needed for other specific vars

        # Optional: Hyprland specific cursor settings if home.pointerCursor isn't enough
        # hyprcursor = {
        #   theme = "Adwaita";
        #   size = 24;
        #   # no_hardware_cursors = false; # Default
        #   # enable_hyprcursor = true; # if you want to force it
        # };

        # --- Appearance (Uncomment and configure as needed) ---
        # decoration = {
        #   rounding = 10;
        #   blur = {
        #     enabled = true;
        #     size = 3;
        #     passes = 1;
        #   };
        #   drop_shadow = true;
        #   # ... other shadow settings
        #   col.shadow = "rgba(1a1a1aee)";
        # };

        # animations = {
        #   enabled = true;
        #   # ... animation settings
        # };
      };
    };

    # Manage cursor theme using home.pointerCursor
    home.pointerCursor = {
      name = "Adwaita";
      size = 24;
      package = pkgs.adwaita-icon-theme;
      gtk.enable = true;
    };

    programs.alacritty.enable = true;
    programs.wlogout.enable = true;
    programs.wofi.enable = true;

    home.packages = with pkgs; [
      grimblast
      swaybg
      pamixer
    ];
  };
  config = {
    programs.light.enable = config.system.isLaptop; # Brightness / backlight control on laptops
    services.playerctld.enable = true; # enable playerctl daemon which scans for background media players
  };
}
