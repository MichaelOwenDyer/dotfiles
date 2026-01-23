{
  inputs,
  ...
}:
{
  # macOS configuration

  flake.modules.darwin.mac =
    { ... }:
    {
      imports = with inputs.self.modules.darwin; [
        default-settings
        macos-disconnect-on-sleep
        michael-mac
      ];

      system.stateVersion = 6;

      # Set Git commit hash for darwin-version
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
}
