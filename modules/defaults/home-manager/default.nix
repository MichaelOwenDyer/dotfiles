{
  inputs,
  ...
}:
{
  # Default settings needed for all homeManagerConfigurations

  flake.modules.homeManager.default-settings =
    { ... }:
    {
      imports = [ inputs.self.modules.homeManager.ssh-client-hosts ];

      programs.home-manager.enable = true;

      home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
}
