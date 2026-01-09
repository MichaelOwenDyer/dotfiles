{
  ...
}:
{
  flake.modules.nixos.cursor-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cursor-cli
      ];
    };

  flake.modules.darwin.cursor-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cursor-cli
      ];
    };

  flake.modules.homeManager.cursor-cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cursor-cli
      ];
    };
}