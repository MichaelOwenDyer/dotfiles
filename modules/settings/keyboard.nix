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

      impermanence.ephemeralPaths = [
        "/etc/kbd" # Console fonts and keymaps
        "/etc/vconsole.conf" # Console configuration
      ];
    };
}
