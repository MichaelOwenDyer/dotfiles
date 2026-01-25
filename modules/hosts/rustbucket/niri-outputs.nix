{
  ...
}:
{
  flake.modules.homeManager.niri-outputs-rustbucket = {
    programs.niri.settings.outputs = {
      "DP-3" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 165.0;
        };
        scale = 2.0;
        position = {
          x = 0;
          y = 0;
        };
      };
      "HDMI-A-1" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 60.0;
        };
        scale = 2.0;
        position = {
          x = -1920;
          y = -360;
        };
      };
    };
  };
}
