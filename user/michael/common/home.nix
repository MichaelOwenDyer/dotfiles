{
  pkgs,
  lib,
  wayland ? true,
  username ? "michael",
  name ? "Michael Dyer",
  email ? "michaelowendyer@gmail.com",
  ...
} @ baseInputs:

let inputs = baseInputs // {
  inherit wayland username name email;
};

in lib.mkMerge [
  {
    programs.home-manager.enable = true;
    services.home-manager.autoExpire = {
      enable = true;
      frequency = "monthly";
      timestamp = "-30 days";
      store.cleanup = true;
    };
    home = {
      inherit username; # Set username to the profile name (the key in config.profiles)
      homeDirectory = "/home/${username}";
      sessionVariables = lib.mkMerge [
        { NIXPKGS_ALLOW_UNFREE = "1"; }
        (lib.mkIf wayland {
          NIXOS_OZONE_WL = "1";
          GTK_USE_PORTAL = "1";
        })
      ];
    };
  }
  (import ./stylix.nix inputs)
  (import ./caffeine.nix (inputs // { enableGnomeIntegration = true; }))
  (import ./browser/firefox.nix (inputs // {
    languagePacks = [ "en-US" ];
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
    ];
  }))
  (import ./browser/zen.nix inputs)
  (import ./development.nix inputs)
  (import ./ide/vscode.nix inputs)
  (import ./ide/helix.nix inputs)
  (import ./shell/fish.nix inputs)
  # I LOVE U; assert iloveyoutoo == true;
]
