{
  ...
}:
{
  flake.modules.nixos.nh =
    { ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          dates = "Mon,Fri *-*-* 03:00:00";
          extraArgs = "--keep 7";
        };
      };
    };

  flake.modules.darwin.nh =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.nh ];
    };

  flake.modules.homeManager.nh =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "${config.home.homeDirectory}/.dotfiles";
      };

      home.sessionVariables = {
        NH_FLAKE = "${config.home.homeDirectory}/.dotfiles";
      };
    };
}
