{
  inputs,
  ...
}:
{
  # Niri scrolling window manager

  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      programs.niri.enable = true;
      programs.dms-shell = {
        enable = true;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        # Core features
        enableSystemMonitoring = true;
        enableClipboard = true;
        enableVPN = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;
      };

      # Battery percentage reporting (for DMS battery widget)
      services.upower.enable = true;

      # Location services (for DMS weather widget)
      services.geoclue2.enable = true;

      environment.systemPackages = with pkgs; [
        fuzzel
        swaylock
        cursor-cli
      ];
    };

  # Clipboard history daemon (for DMS clipboard widget)
  flake.modules.homeManager.niri-clipboard =
    { pkgs, ... }:
    {
      systemd.user.services.cliphist = {
        Unit = {
          Description = "Clipboard history service";
          PartOf = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
