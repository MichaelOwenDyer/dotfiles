{
  ...
}:
{
  # Niri input and output configuration

  flake.modules.homeManager.niri-input = {
    programs.niri.settings = {
      # Input configuration
      input = {
        keyboard = {
          numlock = true;
        };
        touchpad = {
          tap = true;
          drag = true;
          natural-scroll = true;
          accel-speed = 0.1;
          scroll-method = "two-finger";
          scroll-factor = {
            horizontal = 0.35;
            vertical = 0.35;
          };
        };
      };

      # Output configuration
      outputs = {
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
  };
}
