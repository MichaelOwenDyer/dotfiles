{
  homeDirectory
}:

{
  ...
}:

{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d --keep 7";
    };
  };
  home.sessionVariables.NH_FLAKE = "${homeDirectory}/.dotfiles";
}