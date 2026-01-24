{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
