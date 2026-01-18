{
  inputs,
  ...
}:
{
  # Desktop environment

  flake.modules.nixos.laptop =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        desktop
      ];

      # Enable power-profiles-daemon for managing power profiles on laptops
      # services.power-profiles-daemon.enable = true;
    };
}
