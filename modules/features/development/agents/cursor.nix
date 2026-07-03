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
      environment.shellAliases = {
        agent = "cursor-agent";
      };
    };

  flake.modules.darwin.cursor-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        cursor-cli
      ];
      environment.shellAliases = {
        agent = "cursor-agent";
      };
    };

  flake.modules.homeManager.cursor-cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cursor-cli
      ];
      home.shellAliases = {
        agent = "cursor-agent";
      };
    };
}