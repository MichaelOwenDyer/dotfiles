{
  ...
}:
{
  # Zoxide is a smarter cd command that tracks your most used directories

  flake.modules.nixos.zoxide =
    { ... }:
    {
      programs.zoxide.enable = true;
    };

  flake.modules.darwin.zoxide =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.zoxide ];
    };

  flake.modules.homeManager.zoxide =
    { ... }:
    {
      programs.zoxide.enable = true;
    };
}