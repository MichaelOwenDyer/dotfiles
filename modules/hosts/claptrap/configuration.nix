{
  inputs,
  ...
}:
{
  # Dell XPS 13 9360 laptop (temporarily also acting as single-arm router)

  flake.modules.nixos.claptrap =
    { ... }:
    let
      wifiInterface = "wlp58s0";
      tailscaleInterface = "tailscale0";
    in
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
        router
      ];

      networking.hostName = "claptrap";

      router.trunkInterface = "enp0s20f0u2";
      router.trustedInterfaces = [ wifiInterface tailscaleInterface ];

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

      services.speechd.enable = false;
    };
}
