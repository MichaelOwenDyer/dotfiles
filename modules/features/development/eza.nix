{
  inputs,
  ...
}:
{
  # eza: A modern replacement for 'ls' written in Rust

  flake.modules.nixos.eza =
    { ... }:
    {
      programs.eza.enable = true;
    };

  flake.modules.darwin.eza =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [ eza ];
    };

  flake.modules.homeManager.eza =
    { ... }:
    {
      programs.eza.enable = true;
    };
}