{
  inputs,
  ...
}:
let
  username = "michael";
  name = "Michael Dyer";
  email = "michaelowendyer@gmail.com";
in
{
  # Home-Manager configuration for michael
  flake.modules.homeManager.${username} =
    {
      lib,
      ...
    }:
    {
      imports = with inputs.self.modules.homeManager; [
        nh
        ide-helix
        wayland-env
        zen-browser
        mpv
      ];

      home.username = username;
      home.homeDirectory = lib.mkDefault "/home/${username}";

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
        profiles.${username} = {
          isDefault = true;
          search.default = "google";
        };
      };
    };
}
