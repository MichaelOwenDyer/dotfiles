{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Stable nixpkgs for the occasional fallback
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Unstable nixpkgs (used by default)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Master nixpkgs for early access
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  flake.modules = 
    let
      # Core nixpkgs overlay configuration
      overlays = [
        (final: _prev: {
          # Make stable nixpkgs accessible under 'pkgs.stable'
          stable = import inputs.nixpkgs-stable {
            system = final.stdenv.hostPlatform.system;
            config.allowUnfree = final.config.allowUnfree;
          };
          # Make master nixpkgs accessible under 'pkgs.master'
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
