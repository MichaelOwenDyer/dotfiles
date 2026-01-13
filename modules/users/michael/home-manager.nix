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
    {
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        ide-helix
        zen-browser
        mpv
      ];

      home = {
        username = "michael";
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

      # Thunderbird
      programs.thunderbird = {
        enable = true;
        profiles.michael = {
          isDefault = true;
          search.default = "google";
        };
      };
    };
}
