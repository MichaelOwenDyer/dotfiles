{
  ...
}:
{
  # Touchpad with tapping and palm rejection

  flake.modules.nixos.touchpad =
    { ... }:
    {
      services.libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          tappingButtonMap = "lrm"; # 1/2/3 finger tap = left/right/middle
          disableWhileTyping = true;
          clickMethod = "clickfinger";
        };
      };
      services.xserver.synaptics.palmDetect = true;
    };
}
