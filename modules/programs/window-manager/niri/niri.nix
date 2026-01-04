{
  inputs,
  ...
}:
{
  # Niri scrolling window manager
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.niri.nixosModules.niri ];
      # Use the binary cache provided by github:sodiboo/niri-flake to speed up builds
      niri-flake.cache.enable = true;
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable; # Use unstable version - breakages expected
        # package = pkgs.niri-stable;
        # While config is null this will use the default non-tracked ~/.config/niri/config.kdl
        # config = null;
      };
    };
}
