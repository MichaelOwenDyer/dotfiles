{
  inputs,
  ...
}:
{
  flake-file.inputs = {
    # Use managed flake for Niri instead of nixpkgs directly
    niri = {
      url = "github:sodiboo/niri-flake";
    };
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  };
}
