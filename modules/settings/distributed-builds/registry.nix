{
  ...
}:
{
  # Central registry for distributed builds

  flake.lib.distributedBuild = {
    clientKeys = {
      claptrap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQ0T01LHYpwEHrUPz7MAzVAj0QPP2BDyiKdSlL38Yp8 root@claptrap";
    };
    builders = {
      rustbucket = {
        hostName = "rustbucket";
        host-ip = "192.168.0.1";
        systems = [ "x86_64-linux" ];
        maxJobs = 8; # i7-4790K: 4 cores / 8 threads
        speedFactor = 1;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        identityFile = "/root/.ssh/nixremote";
        signingKey = "rustbucket-1:AMe1QbSNHWw+Cyau5rwhAxknUDtmb49vY8tyIbOVAn0=";
      };
    };
  };
}
