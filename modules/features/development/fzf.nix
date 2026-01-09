{
  ...
}:
{
  # fzf - A command-line fuzzy finder

  flake.modules.nixos.fzf =
    { ... }:
    {
      programs.fzf.enable = true;
    };

  flake.modules.darwin.fzf =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fzf ];
    };

  flake.modules.homeManager.fzf =
    { ... }:
    {
      programs.fzf.enable = true;
    };
}