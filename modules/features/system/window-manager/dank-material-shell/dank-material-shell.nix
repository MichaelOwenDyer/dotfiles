{
  inputs,
  ...
}:
{
  flake.modules.nixos.dank-material-shell =
    { ... }:
    {
      imports = [ inputs.dank-material-shell.nixosModules.dank-material-shell ];

      programs.dank-material-shell = {
        enable = true;

        systemd = {
          enable = true;
          restartIfChanged = true;
        };

        enableSystemMonitoring = true;
        enableVPN = true;
        enableDynamicTheming = true;
        enableAudioWavelength = true;
        enableCalendarEvents = true;
      };

      services.upower.enable = true;
      services.geoclue2.enable = true;
    };

  flake.modules.homeManager.dank-material-shell =
    { ... }:
    {
      imports = [
        inputs.dank-material-shell.homeModules.dank-material-shell
        inputs.dank-material-shell.homeModules.niri
      ];

      programs.dank-material-shell = {
        enable = true;

        niri.includes = {
          enable = true;
          override = true;
          # Exclude binds - we define keybinds explicitly in niri-keybinds module
          filesToInclude = [
            "alttab"
            "colors"
            "layout"
            "outputs"
            "wpblur"
          ];
        };
      };
    };
}
