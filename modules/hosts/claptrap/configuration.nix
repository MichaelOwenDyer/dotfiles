{
  inputs,
  ...
}:
{
  # Dell XPS 13 9360 laptop configuration

  flake.modules.nixos.claptrap =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        claptrap-hardware
        laptop
        podman
        ly
        niri
        dank-material-shell
        gnome-keyring
        plymouth
        ssh
        michael-claptrap
      ];

      networking.hostName = "claptrap";

      # XDG portal with GTK as default (for Wayland)
      xdg.portal.config.common.default = [ "gtk" ];

      # Host-specific applications
      programs.zoom-us.enable = true;

      # Reduce wifi scanning on low signal (saves battery)
      networking.wireless.scanOnLowSignal = false;

      system.stateVersion = "24.11";
    };
}
