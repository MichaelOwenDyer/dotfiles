{
  shellAliases ? [ ],
}:

{
  home.shell.enableFishIntegration = true;
  programs.fish = {
    enable = true;
    inherit shellAliases;
  };
}
