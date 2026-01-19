{
  ...
}:
{
  # SSH server configuration - security hardened

  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      settings = {
        # Disable root login entirely (use sudo from regular user)
        # Benefit: Reduces attack surface, enforces audit trail via sudo
        PermitRootLogin = "no";

        # Require SSH keys, no passwords
        # Benefit: Immune to brute-force password attacks
        PasswordAuthentication = false;

        # Disable keyboard-interactive auth (another password vector)
        # Benefit: Ensures only key-based auth is used
        KbdInteractiveAuthentication = false;

        # Disable challenge-response auth
        # Benefit: Prevents PAM-based password prompts
        ChallengeResponseAuthentication = false;

        # Only allow modern, secure key exchange algorithms
        # Benefit: Prevents downgrade attacks to weak ciphers
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "sntrup761x25519-sha512@openssh.com"
        ];

        # Limit authentication attempts per connection
        # Benefit: Slows down brute-force attempts
        MaxAuthTries = 3;

        # Disconnect idle sessions after 15 minutes (3 * 300s)
        # Benefit: Reduces window for session hijacking
        ClientAliveInterval = 300;
        ClientAliveCountMax = 3;

        # Log more details for security auditing
        # Benefit: Better visibility into connection attempts
        LogLevel = "VERBOSE";

        # Enable PAM for session management
        UsePAM = true;
        UseDns = true;

        # Disable X11 forwarding (not needed, potential security risk)
        # Benefit: Reduces attack surface
        X11Forwarding = false;
      };
    };

    # Fail2ban to automatically block repeated failed login attempts
    # Benefit: Automatically bans IPs that show brute-force behavior
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        maxtime = "48h";
        factor = "4";
      };
    };
  };
}
