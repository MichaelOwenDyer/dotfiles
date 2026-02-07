{
  inputs,
  ...
}:
{
  # Gaming PC / build server (MSI Z97A Gaming 7, i7 4790K, 1660 Ti)

  flake.modules.nixos.rustbucket =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        rustbucket-hardware
        desktop
        nvidia
        gaming
        ly
        niri
        dank-material-shell
        gnome-keyring
        plymouth
        ssh
        ssh-client-hosts
        distributed-build-server
        local-streaming-network
        impermanence
        michael-rustbucket
        tailscale
        openclaw
      ];

      networking.hostName = "rustbucket";

      streaming.gateway =
        let rustbucket = inputs.self.lib.hosts.rustbucket;
        in {
          enable = true;
          upstreamInterface = rustbucket.networks.home.interface;
          interface = rustbucket.networks.streaming.interface;
          ipv4Address = rustbucket.networks.streaming.ipv4;
        };

      distributed-build-server = {
        sshUser = "nixremote";
        authorizedClients = with inputs.self.lib.distributedBuild.clients; [
          claptrap.rootSshKey.pub
          rpi-3b.rootSshKey.pub
        ];
        signingKeyPath = "/etc/nix/cache-priv-key.pem";
      };

      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      boot.loader.timeout = 15;

      powerManagement.cpuFreqGovernor = "performance";
      nix.settings.auto-optimise-store = true;
      security.sudo.wheelNeedsPassword = false;

      impermanence.wipeOnBoot = true;

      system.stateVersion = "24.11";
    };
}
