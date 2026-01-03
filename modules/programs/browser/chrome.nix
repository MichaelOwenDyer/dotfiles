{
  inputs,
  ...
}:
{
  # Google Chrome browser

  flake.modules.homeManager.browser-chrome =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ google-chrome ];
    };
}
