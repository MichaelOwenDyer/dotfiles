{
  inputs,
  ...
}:
{
  # eza: A modern replacement for 'ls' written in Rust

  flake.modules.nixos.eza =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.eza ];
    };

  flake.modules.darwin.eza =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.eza ];
    };

  flake.modules.homeManager.eza =
    { ... }:
    {
      programs.eza.enable = true;
    };
}
