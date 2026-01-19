{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Unstable nixpkgs (used by default)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Stable nixpkgs for fallback when unstable has breakages
    # Available as pkgs.stable.* (currently unused)
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Master nixpkgs for early access to fixes/features
    # Available as pkgs.master.* (currently unused)
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  flake.modules =
    let
      # Core nixpkgs overlay configuration
      # Uses throw to ensure lazy evaluation - pkgs.stable/master are only
      # evaluated when actually accessed, reducing build time
      overlays = [
        (final: _prev: {
          # Make stable nixpkgs accessible under 'pkgs.stable' (lazy)
          stable = import inputs.nixpkgs-stable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = final.config.allowUnfree;
          };
          # Make master nixpkgs accessible under 'pkgs.master' (lazy)
          master = import inputs.nixpkgs-master {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = final.config.allowUnfree;
          };
        })
      ];
    in
    {
      nixos.overlays = {
        nixpkgs.overlays = overlays;
      };
      darwin.overlays = {
        nixpkgs.overlays = overlays;
      };
    };
}
