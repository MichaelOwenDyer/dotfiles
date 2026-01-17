{
  inputs,
  ...
}:
{
  # Desktop environment

  flake.modules.nixos.laptop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        desktop
      ];

      # Enable power-profiles-daemon for managing power profiles on laptops
      services.power-profiles-daemon.enable = true;
    };
}
