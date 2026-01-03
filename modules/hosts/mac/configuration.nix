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
        system-cli
      ];

      networking.hostName = "mac";

      # Set Git commit hash for darwin-version
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
}
