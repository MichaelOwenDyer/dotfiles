{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
