{
  inputs,
  ...
}:
{
  # Zen Browser

  flake.modules.homeManager.browser-zen =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.zen-browser.default ];
    };
}
