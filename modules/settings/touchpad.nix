{
  ...
}:
{
  # Touchpad configuration via libinput

  flake.modules.nixos.touchpad =
    { ... }:
    {
      services.libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          tappingButtonMap = "lrm";
          disableWhileTyping = true;
          clickMethod = "clickfinger";
        };
      };
      services.xserver.synaptics.palmDetect = true;
    };
}
