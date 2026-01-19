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

      # Host-specific applications
      programs.zoom-us.enable = true;

      system.stateVersion = "24.11";
    };
}
