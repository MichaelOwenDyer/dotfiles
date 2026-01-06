{
  ...
}:
{
  flake.modules.nixos._1password =
    { pkgs, ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui.enable = true;
    };

  flake.modules.darwin._1password =
    { pkgs, ... }:
    {
      programs._1password.enable = true;
      programs._1password-gui.enable = true;
    };
}
