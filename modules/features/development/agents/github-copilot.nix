{
  ...
}:
{
  flake.modules.nixos.github-copilot-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        github-copilot-cli
      ];
    };

  flake.modules.darwin.github-copilot-cli =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        github-copilot-cli
      ];
    };

  flake.modules.homeManager.github-copilot-cli =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        github-copilot-cli
      ];
    };
}