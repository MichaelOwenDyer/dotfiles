{
  ...
}:
{
  flake-file.inputs = {
    niri-session-manager = {
      url = "github:MTeaHead/niri-session-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "";
      };
    };
  };
}
