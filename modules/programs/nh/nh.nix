{
  inputs,
  ...
}:
{
  # nh - Nix helper tool

  flake.modules.homeManager.nh =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "${config.home.homeDirectory}/.dotfiles";
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d --keep 7";
        };
      };

      home.sessionVariables = {
        NH_FLAKE = "${config.home.homeDirectory}/.dotfiles";
      };
    };
}
