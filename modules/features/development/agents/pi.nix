{
  ...
}:
{
  flake.modules.homeManager.pi =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pi-coding-agent
      ];
    };
}
