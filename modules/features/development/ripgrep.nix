{
  ...
}:
{
  # ripgrep: grep alternative written in Rust

  flake.modules.nixos.ripgrep =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ripgrep ];
    };

  flake.modules.darwin.ripgrep =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.ripgrep ];
    };

  flake.modules.homeManager.ripgrep =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.ripgrep ];
    };
}
