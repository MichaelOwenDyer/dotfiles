{
  inputs,
  ...
}:
{
  flake.modules.nixos.rpi-3b =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager."michael@rpi-3b" ];
      };
    };

  # Host-specific home-manager configuration for michael on rpi-3b
  # Minimal configuration for the Raspberry Pi (no Wayland, no desktop apps)
  flake.modules.homeManager."michael@rpi-3b" =
    { ... }:
    {
      # Remove Wayland-specific config on RPi
      imports = [ inputs.self.modules.homeManager.michael ];

      home.stateVersion = "25.11";
    };
}
