{
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;
    # Enable Waybar as a systemd service (will run on login and restart automatically)
    systemd.enable = true;
    settings.mainBar = {
      # General settings
      position = "top";
      modules-left = [ "tray" ];
      modules-center = [ "clock" ];
      modules-right = [
        "network"
        "battery"
        "cpu"
        "memory"
        "hyprland/workspaces"
        "hyprland/window"
      ];

      # Network module settings
      network = {
        formatUp = "{ifname}: {ipaddr}";
        formatDown = "{ifname}: down";
      };

      # Battery module settings
      battery = {
        format = "{status} {percentage}%";
      };

      # CPU module settings
      cpu = {
        format = "{usage}%";
      };

      # Memory module settings
      memory = {
        format = "{used}/{total} MB";
      };

      # Clock module settings
      clock = {
        format = "%Y-%m-%d %H:%M:%S";
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };
      
      "hyprland/workspaces" = {
        format = "{name}";
        all-outputs = true;
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 50;
      };
    };
  };
}