{
  ...
}:
{
  flake.modules.homeManager.direnv = {
    # Run commands when entering a directory
    programs.direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
  };
}
