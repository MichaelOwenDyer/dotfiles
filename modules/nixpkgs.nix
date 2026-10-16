{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  flake.modules =
    let
      nixpkgs-stable-overlay = final: prev: {
        # Make stable nixpkgs accessible under 'pkgs.stable'
        stable = import inputs.nixpkgs-stable {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = final.config.allowUnfree;
        };
      };
      nixpkgs-master-overlay = final: prev: {
        # Make master nixpkgs accessible under 'pkgs.master'
        master = import inputs.nixpkgs-master {
          system = final.stdenv.hostPlatform.system;
          config.allowUnfree = final.config.allowUnfree;
        };
      };
    in {
      nixos.overlays.nixpkgs.overlays = [ nixpkgs-stable-overlay nixpkgs-master-overlay ];
      darwin.overlays.nixpkgs.overlays = [ nixpkgs-stable-overlay nixpkgs-master-overlay ];
    };
}