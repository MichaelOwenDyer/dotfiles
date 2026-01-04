{
  inputs,
  ...
}:
{
  # Niri scrolling window manager
  flake.modules.nixos.niri =
    { pkgs, ... }:
    {
      imports = [ inputs.niri-flake.nixosModules.niri ];
      # Use the binary cache provided by github:sodiboo/niri-flake to speed up builds
      niri-flake.cache.enable = true;
      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable; # Use unstable version - breakages expected
        # package = pkgs.niri-stable;
        # config = ''

        # '';
      };
      environment.systemPackages = with pkgs; [
        playerctl # For media hotkeys
        brightnessctl # For brightness hotkeys
        fuzzel # lightweight application launcher
        swaylock # screen locker
      ];
    };
}
