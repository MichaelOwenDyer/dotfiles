{
  ...
}:
{
  flake.modules.nixos._1password =
    { ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui.enable = true;
    };

  flake.modules.darwin._1password =
    { ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui.enable = true;
    };
}
