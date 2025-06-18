{
  username,
  wayland,
  languagePacks ? [ "en-US" ],
  extensions ? [ ],
}:

{
  lib,
  pkgs,
  ...
}:

{
  home.sessionVariables = lib.mkIf wayland {
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable firefox
  programs.firefox = {
    enable = true;
    package = if wayland then pkgs.firefox-wayland else pkgs.firefox;
    inherit languagePacks;
    profiles."${username}".extensions.packages = extensions;
  };
}
