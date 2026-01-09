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
        macos-disconnect-on-sleep
        orbstack
        shell-alias-cd-zoxide
        shell-alias-cat-bat
        shell-alias-ls-eza
      ];

      system.stateVersion = 6;

      # Set Git commit hash for darwin-version
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };
}
