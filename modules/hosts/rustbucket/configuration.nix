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
        # local-streaming-network
        michael-rustbucket
      ];

      networking.hostName = "rustbucket";

      # Performance mode for gaming desktop
      powerManagement.cpuFreqGovernor = "performance";

      # Optimize nix store after each build
      nix.settings.auto-optimise-store = true;

      # Static IP for wifi interface
      networking.interfaces.wlan0.ipv4.addresses = [
        { address = "192.168.0.1"; prefixLength = 24; }
      ];

      # Passwordless sudo for convenience on personal gaming machine
      security.sudo.wheelNeedsPassword = false;

      # Longer boot menu timeout for dual-boot selection
      boot.loader.timeout = 15;

      system.stateVersion = "24.11";
    };
}
