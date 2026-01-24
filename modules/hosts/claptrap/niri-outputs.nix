{
  ...
}:
{
  flake.modules.homeManager.niri-outputs-claptrap = {
    programs.niri.settings.outputs = {
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
  };
}
