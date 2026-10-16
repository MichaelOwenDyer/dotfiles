{
  ...
}:
{
  flake.modules.nixos.bruno =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bruno-cli
        bruno
      ];
    };

  flake.modules.darwin.bruno =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bruno-cli
        bruno
      ];
    };

  flake.modules.homeManager.bruno =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        bruno-cli
        bruno
      ];
    };
}