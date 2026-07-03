{
  ...
}:
{
  flake.modules.homeManager.typst =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ typst typstyle typst-live ];
    };
}
