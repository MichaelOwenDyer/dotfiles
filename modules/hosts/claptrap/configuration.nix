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
        ly
        niri
        dank-material-shell
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
          rustbucket-home
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [
        inputs.self.lib.sshKeys."michael@rustbucket".pub
      ];

      system.stateVersion = "24.11";
    };
}
