{
  inputs,
  ...
}:
{
  # Niri scrolling window manager
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      # Use the binary cache provided by 
      niri-flake.cache.enable = true;
      programs.niri = {
        enable = true;
        # package = pkgs.niri-unstable; # Use unstable version - breakages expected
        package = pkgs.niri-stable;
        # While config is null this will use the default non-tracked ~/.config/niri/config.kdl
        config = null;
      };
    };
}
