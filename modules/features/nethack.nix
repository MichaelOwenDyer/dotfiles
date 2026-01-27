{
  ...
}:
{
  flake.modules.homeManager.nethack =
  { pkgs, ... }:
  {
    home.packages = [ pkgs.nethack ];
  };
}
