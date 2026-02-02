{
  inputs,
  ...
}:
{
  # Assign user michael to host mac

  flake.modules.darwin.michael-mac =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        home-manager # Add home-manager to this system
        # michael # TODO: use common michael settings when available
        macos-disconnect-on-sleep
        tailscale
      ];

      home-manager.users."michael.dyer" = {
        imports = [ inputs.self.modules.homeManager.michael-mac ];
      };

      users.users."michael.dyer" = {
        name = "michael.dyer";
        home = "/Users/michael.dyer";
        shell = pkgs.zsh;
      };

      system.primaryUser = "michael.dyer";
    };

  # Host-specific home-manager configuration for michael on mac
  flake.modules.homeManager.michael-mac =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        # michael # TODO: use common michael settings when available
        default-settings
        work
      ];

      programs.git.settings.user = {
        name = "Michael Dyer";
        email = "michael.dyer@check24.de";
      };

      home.packages = with pkgs; [
        alt-tab-macos
        mos
        scroll-reverser
        hours
        nodejs_24
        pnpm_9
        maven
        gradle_9
      ];

      home = {
        username = "michael.dyer";
        homeDirectory = "/Users/michael.dyer";
        stateVersion = "26.05";
      };
    };
}
