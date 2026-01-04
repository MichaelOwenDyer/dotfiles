{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Use managed flake for Niri instead of nixpkgs directly
    niri-flake = {
      url = "github:sodiboo/niri-flake";
    };
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];
  };
}
