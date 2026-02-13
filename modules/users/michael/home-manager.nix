{
  inputs,
  ...
}:
let
  name = "Michael Dyer";
  email = "michaelowendyer@gmail.com";
in
{
  # Home-Manager configuration for michael
  flake.modules.homeManager.michael =
    { lib, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        cli
        fish-shell
        nushell
        ide-helix
        zen-browser
        loupe
        nethack
      ];

      home = {
        username = lib.mkDefault "michael";
        homeDirectory = lib.mkDefault "/home/michael";
      };

      # Git configuration with user info
      programs.git.settings.user = {
        inherit name email;
      };

      # Jujutsu configuration
      programs.jujutsu.settings.user = {
        inherit name email;
      };

      # Ghostty: open in dotfiles directory
      programs.ghostty.settings.working-directory = "/home/michael/.dotfiles";

      # Thunderbird
      # programs.thunderbird = {
      #   enable = true;
      #   profiles.michael = {
      #     isDefault = true;
      #     search.default = "google";
      #   };
      # };
    };
}
