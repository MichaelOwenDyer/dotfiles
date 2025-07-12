{
  homeDirectory
}:

{
  ...
}:

{
  programs.nh = {
    enable = true;
    flake = "${homeDirectory}/.dotfiles";
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 7d --keep 7";
    };
  };
}
