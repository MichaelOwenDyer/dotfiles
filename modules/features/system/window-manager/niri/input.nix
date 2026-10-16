{
  ...
}:
{
  # Niri input configuration (shared across hosts)

  flake.modules.homeManager.niri-input = {
    programs.niri.settings.input = {
      keyboard = {
        numlock = true;
      };
      mouse = {
        scroll-factor = 1.0;
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
  };
}
