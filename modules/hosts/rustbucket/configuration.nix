{
  inputs,
  ...
}:
{
  # Gaming PC configuration (MSI Z97A Gaming 7, i7 4790K, 1660 Ti)

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
        distributed-build-server
        local-streaming-network
        impermanence
        tailscale
        adguardhome
        michael-rustbucket
      ];

      networking.hostName = "rustbucket";

      # Local streaming network configuration
      localStreaming = {
        enable = true;
        wifiInterface = "wlan0";
        wifiDefaultGateway = "192.168.0.254";
        streamingInterface = "enp4s0";
        streamingIpv4Addr = "192.168.50.1";
        streamingIpv6Addr = "fdc9:1a4b:53e1:50::1";
        upstreamDnsServers = [
          "8.8.8.8"
          "4.4.4.4"
        ];
      };

      distributed-build.server = with inputs.self.lib.distributedBuild; {
        sshUser = "nixremote";
        authorizedClients = [ clients.claptrap.rootSshKey.pub clients.rpi-3b.rootSshKey.pub ];
        signingKeyPath = "/etc/nix/cache-priv-key.pem";
      };

      # Performance mode for gaming desktop
      powerManagement.cpuFreqGovernor = "performance";

      # Optimize nix store after each build
      nix.settings.auto-optimise-store = true;

      # Passwordless sudo for convenience on personal gaming machine
      security.sudo.wheelNeedsPassword = false;

      # Longer boot menu timeout for dual-boot selection
      boot.loader.timeout = 15;

      # Impermanence - wipe root on every boot
      # Persistence is configured by individual modules (wifi, bluetooth, ssh, etc.)
      impermanence.wipeOnBoot = true;

      system.stateVersion = "24.11";
    };
}
