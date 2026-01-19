{
  ...
}:
{
  # US keyboard layout

  flake.modules.nixos.keyboard-us =
    { ... }:
    {
      console.keyMap = "us";
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };
}
