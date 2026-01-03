{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Zen Browser
    zen-browser = {
      url = "github:MichaelOwenDyer/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
