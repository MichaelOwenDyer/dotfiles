# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    dank-material-shell = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:AvengeMedia/DankMaterialShell/stable";
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };
    impermanence = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/impermanence";
    };
    import-tree.url = "github:vic/import-tree";
    niri-flake.url = "github:sodiboo/niri-flake";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin";
    };
    nix-openclaw = {
      inputs = {
        home-manager.follows = "home-manager";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:openclaw/nix-openclaw";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    noctalia = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:noctalia-dev/noctalia-shell";
    };
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };
    systems.url = "github:nix-systems/default";
    zen-browser = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:MichaelOwenDyer/zen-browser-flake";
    };
  };

}
