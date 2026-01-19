{
  ...
}:
{
  # Hardened SSH server with fail2ban

  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        ChallengeResponseAuthentication = false;
        X11Forwarding = false;

        # Modern key exchange algorithms only
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "sntrup761x25519-sha512@openssh.com"
        ];

        MaxAuthTries = 3;

        # Disconnect idle sessions after 15 minutes
        ClientAliveInterval = 300;
        ClientAliveCountMax = 3;

        LogLevel = "VERBOSE";
        UsePAM = true;
        UseDns = true;
      };
    };

    # Auto-ban IPs after repeated failed login attempts
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
