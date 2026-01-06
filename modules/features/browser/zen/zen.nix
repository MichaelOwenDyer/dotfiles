{
  inputs,
  ...
}:
{
  # Zen Browser

  flake.modules.homeManager.zen-browser =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.zen-browser ];
    };
}
