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

      environment.systemPackages = with pkgs; [
        fuzzel
        swaylock
        cursor-cli
      ];
    };
}
