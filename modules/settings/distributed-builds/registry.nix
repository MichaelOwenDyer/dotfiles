{
  inputs,
  ...
}:
{
  # Central registry for distributed builds

  flake.lib.distributedBuild = with inputs.self.lib; {
    clients = {
      claptrap = {
        rootSshKey = sshKeys."root@claptrap";
      };
      rpi-3b = {
        rootSshKey = sshKeys."root@rpi-3b";
      };
    };
    builders = {
      rustbucket = {
        hostName = "rustbucket";
        host-ip = "192.168.0.1";
        systems = [ "x86_64-linux" "aarch64-linux" ];
        maxJobs = 8; # i7-4790K: 4 cores / 8 threads
        speedFactor = 1;
        protocol = "ssh-ng";
        sshUser = "nixremote";
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        # This host is also a substituter / binary cache
        signingKey = "rustbucket-1:AMe1QbSNHWw+Cyau5rwhAxknUDtmb49vY8tyIbOVAn0=";
      };
    };
  };
}
