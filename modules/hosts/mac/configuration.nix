{
  inputs,
  ...
}:
{
  # macOS configuration

  flake.modules.darwin.mac =
    { ... }:
    {
      imports = with inputs.self.modules.darwin; [
        default-settings
        work
        michael-mac
      ];

      system.stateVersion = 6;

      # Set Git commit hash for darwin-version
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    };

  flake.lib.hosts.mac = {
    hostName = "mac";
    tailscaleHostName = "jgfqqxm192";
    system = "aarch64-darwin";
    networks = {
      home = { ipv4 = "192.168.1.12"; interface = "en0"; mac = "80:a9:97:3c:54:8c"; };
      tailscale = { ipv4 = "100.111.69.23"; ipv6 = "fd7a:115c:a1e0::4d37:4517"; };
    };
    build = {
      maxJobs = 10;
      speedFactor = 2;
      supportedSystems = [ "aarch64-darwin" "x86_64-darwin" ];
      supportedFeatures = [ ];
      signingKey = null;
    };
  };
}
