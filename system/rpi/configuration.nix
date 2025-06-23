{
  hostname,
  users
}:

{
  hardware,
  ...
}:

{
  imports = [
    (import ../nixos_default.nix { inherit hostname users; })
    ./hardware-configuration.nix
    hardware.raspberry-pi-3
  ];

  console.font = "Lat2-Terminus16";

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking = {
    networkmanager.enable = true;
    defaultGateway = {
      interface = "enu1u1";
      address = "192.168.0.254";
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    interfaces.enu1u1 = {
      ipv4.addresses = [{
        address = "192.168.0.253";
        prefixLength = 24;
      }];
    };
  };

  # Enable the Pi-hole service
  # services.pi-hole = {
  #   enable = true;
  #   # The interface Pi-hole should listen on. Must match your static IP interface.
  #   interface = "eth0";
  #   # Enable the web interface for administration
  #   webInterface = true;

  #   # Host-specific container configuration
  #   hostConfig = {
  #     # It's recommended to run Pi-hole in a rootless container for security.
  #     # Create a dedicated user for Pi-hole.
  #     user = "pihole";
  #     group = "pihole";

  #     # Expose necessary ports. 53 for DNS, 80 for Web UI, 443 for HTTPS (if enabled).
  #     # Adjust the host port if 80 or 443 conflict (e.g., "8080:80").
  #     ports = [
  #       "53:53/tcp"
  #       "53:53/udp"
  #       "80:80/tcp"
  #       "443:443/tcp"
  #     ];

  #     # Persist Pi-hole data outside the container for updates and reboots.
  #     # This ensures your blocklists, DHCP leases, etc., are saved.
  #     # You can choose a path like /var/lib/pihole or /opt/pihole.
  #     persistVolumes = true;
  #     volumesPath = "/var/lib/pihole-data"; # Where Pi-hole volumes will be stored on the host
  #   };

  #   # Pi-hole specific configuration (equivalent to environment variables)
  #   piholeConfig = {
  #     # Upstream DNS servers for Pi-hole itself to query.
  #     # You can specify multiple, e.g., Cloudflare, Google DNS.
  #     DNS1 = "1.1.1.1";
  #     DNS2 = "1.0.0.1";
  #     # Set your timezone
  #     TZ = "Europe/Berlin"; # Adjust to your timezone, e.g., "America/New_York"
  #     # Set the admin password for the web interface.
  #     # It's highly recommended to set this!
  #     # You can generate a hash using `pihole -a -p` after installation, or set it here.
  #     # If not set here, you'll need to set it manually via `pihole -a -p` after first boot.
  #     # WEBPASSWORD = "your_strong_password_here"; # Uncomment and set a strong password.
  #     # FTLCONF_REPLY_WHEN_BUSY = "true"; # Example of another FTLDNS setting
  #   };

  #   # DHCP Server (Optional: if you want Pi-hole to act as your DHCP server)
  #   # Be careful: only one DHCP server should be active on your network.
  #   # If your router handles DHCP, leave this disabled.
  #   # If you enable this, disable DHCP on your router!
  #   # dhcp = {
  #   #   enable = false;
  #   #   interface = "eth0";
  #   #   range = "192.168.1.20 192.168.1.250";
  #   #   router = "192.168.1.1"; # Your router's IP
  #   #   domain = "home.arpa"; # Your local domain
  #   # };
  # };

  # Firewall configuration
  # networking.firewall.enable = true;
  # Allow essential services: SSH, DNS, HTTP, HTTPS
  # networking.firewall.allowedTCPPorts = [ 22 80 443 ];
  # networking.firewall.allowedUDPPorts = [ 53 67 ]; # 53 for DNS, 67 for DHCP if enabled

  # Users and groups for the rootless Pi-hole container
  # users.users.pihole = {
    # isSystem = true;
    # group = "pihole";
    # uid = config.ids.uids.pihole; # Get an allocated UID from NixOS
  # };
  # users.groups.pihole = {
    # isSystem = true;
    # gid = config.ids.gids.pihole; # Get an allocated GID from NixOS
  # };

  # Required for rootless containers to allocate UIDs/GIDs
  # This makes NixOS manage subuids/subgids for the 'pihole' user.
  # virtualisation.podman.enable = true; # Required for services.pi-hole
  # users.users.pihole.extraGroups = [ "podman" ]; # Allow pihole user to interact with podman
  # Enable and configure subuids/subgids for the rootless container user.
  # This is crucial for rootless Podman containers.
  # You might need to set these manually if auto-detection fails,
  # but NixOS usually handles this via the user declaration.
  # You can verify with `cat /etc/subuid` and `cat /etc/subgid` after build.

  system.stateVersion = "25.11";
}
