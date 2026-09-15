{
  ...
}:
{
  flake.modules.homeManager.niri-outputs-rustbucket = {
    programs.niri.settings.outputs = {
      "HDMI-A-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 59.939;
        };
        scale = 1.5;
        position = {
          x = 0;
          y = 0;
        };
      };
      "DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
          refresh = 165.0;
        };
        scale = 1.0;
      };
    };
  };
}
