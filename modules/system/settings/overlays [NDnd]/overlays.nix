{
  inputs,
  ...
}:
let
  # Shared overlay configuration
  overlays = [
    # Make stable and master nixpkgs accessible
    (final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.system;
        config.allowUnfree = final.config.allowUnfree;
      };
      master = import inputs.nixpkgs-master {
        system = final.system;
        config.allowUnfree = final.config.allowUnfree;
      };
      zen-browser = inputs.zen-browser.packages.${final.system};
      nix-wallpaper = inputs.nix-wallpaper.packages.${final.system}.default;
    })
    # NUR overlay makes packages accessible under 'pkgs.nur'
    inputs.nur.overlays.default
    # nh overlay makes nh accessible under 'pkgs.nh'
    inputs.nh.overlays.default
  ];
in
{
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = overlays;
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = overlays;
  };

  flake.modules.homeManager.overlays = {
    nixpkgs.overlays = overlays;
  };
}
