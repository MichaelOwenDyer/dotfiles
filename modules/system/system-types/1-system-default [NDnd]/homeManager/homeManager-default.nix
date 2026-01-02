{
  inputs,
  ...
}:
{
  # Default settings needed for all homeManagerConfigurations

  flake.modules.homeManager.system-default =
    { ... }:
    {
      programs.home-manager.enable = true;

      home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
}
