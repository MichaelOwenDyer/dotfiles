{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.darwinConfigurations = inputs.self.lib.mkDarwin "x86_64-darwin" "mac";
}
