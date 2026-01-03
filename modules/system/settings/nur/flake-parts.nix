# Makes NUR packages accessible under 'pkgs.nur' in NixOS and Darwin systems
{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # NUR (Nix User Repository) - community packages
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = [ inputs.nur.overlays.default ];
  };
}
