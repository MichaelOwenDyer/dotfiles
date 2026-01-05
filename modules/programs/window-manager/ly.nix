{
  ...
}:
{
  # Minimalist ly login manager

  flake.modules.nixos.ly =
    { ... }:
    {
      services.displayManager.ly.enable = true;
    };
}