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
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = final.config.allowUnfree;
      };
      master = import inputs.nixpkgs-master {
        system = final.stdenv.hostPlatform.system;
        config.allowUnfree = final.config.allowUnfree;
      };
      zen-browser = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system};
      nix-wallpaper = inputs.nix-wallpaper.packages.${final.stdenv.hostPlatform.system}.default;
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

  # Since home-manager.useGlobalPkgs = true, configuring its nixpkgs instance is not allowed
  # flake.modules.homeManager.overlays = {
  #   nixpkgs.overlays = overlays;
  # };
}
