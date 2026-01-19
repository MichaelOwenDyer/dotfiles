{
  ...
}:
{
  # US keyboard layout configuration

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
