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

      homebrew.casks = [
        "arc"
        "google-chrome"
        "rustdesk"
        "vlc"
        "whatsapp"
        "dolphin"
        "discord"
        "zotero"
        "ausweisapp"
      ];

      homebrew.brews = [
        "z3"
      ];
    };

  # Host-specific home-manager configuration for michael on mac
  flake.modules.homeManager.michael-mac =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        # michael # TODO: use common michael settings when available
        default-settings
        work
        nethack
        typst
      ];

      programs.git.settings.user = {
        name = "Michael Dyer";
        email = "michaelowendyer@gmail.com";
      };

      home = {
        username = "michael.dyer";
        homeDirectory = "/Users/michael.dyer";
        stateVersion = "26.05";
        packages = with pkgs; [
          poppler
        ];
      };
    };
}
