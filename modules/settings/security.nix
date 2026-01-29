{
  ...
}:
{
  # Security defaults

  flake.modules.nixos.security-defaults =
    { ... }:
    {
      # Modern alternatives to legacy subsystems
      networking.nftables.enable = true; # Replaces iptables
      services.dbus.implementation = "broker"; # Faster, more secure D-Bus

      impermanence.ephemeralPaths = [
        # Authentication
        "/etc/pam"
        "/etc/pam.d"
        # Certificates
        "/etc/ssl"
        "/etc/pki"
        # IPsec (generated even if not using VPN)
        "/etc/ipsec.secrets"
        # D-Bus
        "/etc/dbus-1"
        # Firewall
        "/var/lib/nftables"
      ];
    };
}
