{
  inputs,
  ...
}:
{
  # Dell XPS 13 9360 laptop

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
        ssh-client-hosts
        distributed-build-client
        michael-claptrap
      ];

      networking.hostName = "claptrap";

      distributed-build-client = {
        rootSshKey = inputs.self.lib.distributedBuild.clients.claptrap.rootSshKey;
        builders = with inputs.self.lib.distributedBuild.builders; [
          rustbucket-streaming
          rustbucket-home
          rustbucket-tailscale
        ];
      };

      programs.zoom-us.enable = true;

      users.users.root.openssh.authorizedKeys.keys = [
        inputs.self.lib.sshKeys."michael@rustbucket".pub
      ];

      system.stateVersion = "24.11";
    };
}
