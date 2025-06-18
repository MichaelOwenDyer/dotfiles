{
  wayland ? true,
  username ? "michael",
  name ? "Michael Dyer",
  email ? "michaelowendyer@gmail.com"
}:

{
  lib,
  pkgs,
  ...
}:

{
  # I LOVE U; assert iloveyoutoo == true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "monthly";
    timestamp = "-30 days";
    store.cleanup = true;
  };
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionVariables = lib.mkMerge [
      { NIXPKGS_ALLOW_UNFREE = "1"; }
      (lib.mkIf wayland { NIXOS_OZONE_WL = "1"; GTK_USE_PORTAL = "1"; })
    ];
  };

  imports = [
    ./stylix.nix
    ./ide/vscode.nix
    ./ide/helix.nix
    (import ./caffeine.nix { enableGnomeIntegration = true; })
    (import ./development.nix { inherit name email; })
    (import ./shell/fish.nix { })
    ./browser/zen.nix
    (import ./browser/firefox.nix {
      inherit username wayland;
      languagePacks = [ "en-US" "de-DE" ];
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
      ];
    })
  ];
}
