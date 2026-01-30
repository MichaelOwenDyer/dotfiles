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
        tailscale
        plymouth
        ssh
        distributed-build-client
        michael-claptrap
      ];

      networking.hostName = "claptrap";

      distributed-build.client = with inputs.self.lib.distributedBuild; {
        publicKey = clientKeys.claptrap;
        builders = [ builders.rustbucket ];
      };

      programs.zoom-us.enable = true;

      system.stateVersion = "24.11";
    };
}
