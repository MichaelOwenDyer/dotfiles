{
  ...
}:
{
  flake.modules.nixos.orbstack =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.orbstack ];
    };

  flake.modules.darwin.orbstack =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        orbstack
      ];
    };

  flake.modules.homeManager.orbstack =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.orbstack ];
    };
}