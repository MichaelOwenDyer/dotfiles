{
  inputs,
  ...
}:
{
  # Laptop environment

  flake.modules.nixos.laptop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        desktop
      ];
    };
}
