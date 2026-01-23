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
        # local-streaming-network
        michael-rustbucket
      ];

      networking.hostName = "rustbucket";

      distributed-build.server = with inputs.self.lib.distributedBuild; {
        authorizedKeys = [ clientKeys.claptrap ];
      };

      # Performance mode for gaming desktop
      powerManagement.cpuFreqGovernor = "performance";

      # Optimize nix store after each build
      nix.settings.auto-optimise-store = true;

      # Passwordless sudo for convenience on personal gaming machine
      security.sudo.wheelNeedsPassword = false;

      # Longer boot menu timeout for dual-boot selection
      boot.loader.timeout = 15;

      system.stateVersion = "24.11";
    };
}
