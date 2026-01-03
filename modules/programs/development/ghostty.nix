{
  ...
}:
{
  flake.modules.nixos.ghostty = {
    programs.ghostty = {
      enable = true;
    };
  };

  flake.modules.homeManager.ghostty = {
    programs.ghostty = {
      enable = true;
    };
  };
}
