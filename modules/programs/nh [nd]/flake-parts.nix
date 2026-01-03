{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Nix build tool
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
