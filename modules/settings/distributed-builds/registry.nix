{
  ...
}:
{
  # Central registry for distributed builds

  flake.lib.distributedBuild = {
    clients = {
      claptrap = {
        rootSshKey = {
          pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQ0T01LHYpwEHrUPz7MAzVAj0QPP2BDyiKdSlL38Yp8 root@claptrap";
          privatePath = "/root/.ssh/nixremote"; # Expect the corresponding private key to be available here
        };
      };
      rpi-3b = {
        rootSshKey = {
          pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPQY1jga8pE59ErPEGTt5Rz0GjwGKJq8svjeWWnqeSc root@rpi-3b";
          privatePath = "/root/.ssh/nixremote";
        };
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
