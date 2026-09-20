{ ... }:
{
  flake.modules.homeManager.rust =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        jetbrains.rust-rover
        rustup
        gcc
      ];
    };
}
