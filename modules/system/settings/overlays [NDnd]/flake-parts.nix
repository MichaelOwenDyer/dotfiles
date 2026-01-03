{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Unstable nixpkgs (used by default)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Master nixpkgs for early access
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    # Stable nixpkgs for the occasional fallback
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # NUR (Nix User Repository) - community packages
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
