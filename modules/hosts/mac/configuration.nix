{
  inputs,
  ...
}:
{
  # macOS configuration

  flake.modules.darwin.mac =
    { lib, config, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        default-settings
        home-manager
        essential-packages
        _1password
      ];

      system.stateVersion = 6;

      # Set Git commit hash for darwin-version
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
}
