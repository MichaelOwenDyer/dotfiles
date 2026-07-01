{
  ...
}:
{
  flake-file.inputs = {
    niri-session-manager = {
      url = "github:MTeaHead/niri-session-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
    };
  };
}
