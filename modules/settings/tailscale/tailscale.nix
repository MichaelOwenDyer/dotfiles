{
  ...
}:
{
  # Tailscale - Mesh VPN for secure remote access
  # https://tailscale.com
  #
  # Tailscale creates a WireGuard-based mesh VPN that works through NAT/CGNAT.
  # This is ideal for DS-Lite connections where you can't port forward.
  #
  # Features:
  # - Automatic NAT traversal (works behind CGNAT)
  # - Each device gets a stable 100.x.x.x IP
  # - Optional "Funnel" for public internet exposure
  # - MagicDNS for hostname resolution within tailnet
  #
  # For fully FOSS alternative, see Headscale (self-hosted control plane)

  flake.modules.nixos.tailscale =
    { lib, pkgs, ... }:
    {
      config = {
        # Sensible defaults for Tailscale
        services.tailscale = {
          enable = true;
          useRoutingFeatures = lib.mkDefault "client";
          openFirewall = lib.mkDefault true;
        };

        # Install tailscale CLI
        environment.systemPackages = [ pkgs.tailscale ];

        # Persist Tailscale state with impermanence
        impermanence.persistedDirectories = [
          "/var/lib/tailscale"
        ];
      };
    };
}
