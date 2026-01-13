{
  ...
}:
{
  # fzf - A command-line fuzzy finder

  flake.modules.nixos.fzf =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fzf ];
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
