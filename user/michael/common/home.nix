{
  pkgs,
  lib,
  wayland ? true,
  username ? "michael",
  name ? "Michael Dyer",
  email ? "michaelowendyer@gmail.com",
  ...
} @ inputs:

lib.mkMerge [
  {
    programs.home-manager.enable = true;
    home = {
      inherit username; # Set username to the profile name (the key in config.profiles)
      homeDirectory = "/home/${username}";
      sessionVariables = lib.mkIf wayland {
        NIXOS_OZONE_WL = "1";
        GTK_USE_PORTAL = "1";
      };
    };
  }
  (import ./stylix.nix inputs)
  (import ./caffeine.nix (inputs // { enableGnomeIntegration = true; }))
  (import ./browser/firefox.nix {
    inherit pkgs lib username wayland;
    languagePacks = [ "en-US" ];
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
    ];
  })
  (import ./browser/zen.nix inputs)
  (import ./development.nix (inputs // { inherit name email; }))
  (import ./ide/vscode.nix inputs)
  (import ./ide/helix.nix inputs)
  # I LOVE U; assert iloveyoutoo == true;
]
