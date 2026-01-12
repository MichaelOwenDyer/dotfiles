{
  ...
}:
{
  # ripgrep: grep alternative written in Rust

  flake.modules.nixos.ripgrep =
    { ... }:
    {
      environment.systemPackages = [ pkgs.ripgrep ];
    };

  flake.modules.darwin.ripgrep =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ripgrep ];
    };

  flake.modules.homeManager.ripgrep =
    { ... }:
    {
      home.packages = [ pkgs.ripgrep ];
    };
}