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

        # Note: Tailscale Serve/Funnel configuration is done via CLI:
        #   tailscale serve https / http://127.0.0.1:18789
        #   tailscale funnel 443 on
        #
        # This could be automated with a systemd service, but the CLI
        # approach is more flexible and allows runtime changes.
        #
        # For clawdbot specifically, the gateway can auto-configure
        # Tailscale Serve/Funnel via its config:
        #   gateway.tailscale.mode = "serve" | "funnel"
      };
    };
}
