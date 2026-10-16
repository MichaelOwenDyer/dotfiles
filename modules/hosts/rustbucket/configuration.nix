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
        impermanence
        michael-rustbucket
        tailscale
        syncthing
      ];

      networking.hostName = "rustbucket";

      # streaming.gateway =
      #   let rustbucket = inputs.self.lib.hosts.rustbucket;
      #   in {
      #     enable = true;
      #     upstreamInterface = rustbucket.networks.home.interface;
      #     interface = rustbucket.networks.streaming.interface;
      #     ipv4Address = rustbucket.networks.streaming.ipv4;
      #   };

      distributed-build-server = {
        sshUser = "nixremote";
        authorizedClients = with inputs.self.lib.distributedBuild.clients; [
          claptrap.rootSshKey.pub
          rpi-3b.rootSshKey.pub
        ];
        signingKeyPath = "/etc/nix/cache-priv-key.pem";
        binaryCachePort = inputs.self.lib.hosts.rustbucket.build.binaryCachePort;
      };

      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
      boot.loader.timeout = 15;

      powerManagement.cpuFreqGovernor = "performance";
      nix.settings.auto-optimise-store = true;
      security.sudo.wheelNeedsPassword = false;

      impermanence.wipeOnBoot = true;

      system.stateVersion = "24.11";
    };

  flake.lib.keys = {
    signing.rustbucket = {
      pub = "rustbucket-1:AMe1QbSNHWw+Cyau5rwhAxknUDtmb49vY8tyIbOVAn0=";
      privateKeySecret = "nix-signing-rustbucket";
      deployPath = "/etc/nix/cache-priv-key.pem";
      owner = "root";
    };
    ssh.host.rustbucket = {
      pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGw0ssMwpvMC+mVlHIrRnYaIV+oCaRj6jiyxL9wu1Mr7 root@rustbucket";
      path = "/etc/ssh/ssh_host_ed25519_key";
      persistPath = "/persist/etc/ssh/ssh_host_ed25519_key";
    };
  };
}
