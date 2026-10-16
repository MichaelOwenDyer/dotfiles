{
  ...
}:
{
  # Cursor IDE configuration

  flake.modules.homeManager.ide-cursor =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ code-cursor ];
    };
}
