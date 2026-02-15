{
  inputs,
  ...
}:
{
  # Default settings needed for all homeManagerConfigurations

  flake.modules.homeManager.default-settings =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        nix-settings
        ssh-client-hosts
      ];

      programs.home-manager.enable = true;
    };
}
