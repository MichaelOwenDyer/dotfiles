{
  ...
}:
{
  # fd, a "find" alternative

  flake.modules.nixos.fd =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fd ];
    };

  flake.modules.darwin.fd =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.fd ];
    };

  flake.modules.homeManager.fd =
    { ... }:
    {
      programs.fd = {
        enable = true;
        hidden = true;
      };
    };
}
