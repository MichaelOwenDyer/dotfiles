{
  ...
}:
{
  # bat is an enhanced cat command with syntax highlighting and Git integration

  flake.modules.nixos.bat =
    { ... }:
    {
      programs.bat.enable = true;
    };

  flake.modules.darwin.bat =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.bat ];
    };

  flake.modules.homeManager.bat =
    { ... }:
    {
      programs.bat.enable = true;
    };
}