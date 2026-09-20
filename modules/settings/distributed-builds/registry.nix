{
  inputs,
  ...
}:
{
  # Distributed build registry

  flake.lib.distributedBuild =
    let
      inherit (inputs.self.lib) hosts hostsLib sshKeys;

      mkBuilder =
        hostName:
        {
          network,
          speedMultiplier ? 1,
        }:
        let
          host = hosts.${hostName};
          host-ipv4 = hostsLib.getIpForNetwork network host;
        in
        {
          inherit hostName network host-ipv4;
          systems = host.build.supportedSystems;
          maxJobs = host.build.maxJobs;
          speedFactor = host.build.speedFactor * speedMultiplier;
          protocol = "ssh-ng";
          sshUser = "nixremote";
          supportedFeatures = host.build.supportedFeatures;
          signingKey = host.build.signingKey;
          binaryCacheUrl = "http://${host-ipv4}:${toString host.build.binaryCachePort}";
        };
    in
    {
      clients = {
        claptrap.rootSshKey = sshKeys."root@claptrap";
        rpi-3b.rootSshKey = sshKeys."root@rpi-3b";
      };

      builders = {
        rustbucket-tailscale = mkBuilder "rustbucket" {
          network = "tailscale";
          speedMultiplier = 1;
        };
        rustbucket-home = mkBuilder "rustbucket" {
          network = "home";
          speedMultiplier = 2;
        };
      };
    };
}
