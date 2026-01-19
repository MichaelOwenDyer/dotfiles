{
  ...
}:
{
  # Base distributed build client module
  # Host-specific client modules (client-rustbucket, client-mac) import this

  flake.modules.nixos.distributed-build-client =
    { lib, config, ... }:
    {
      options.distributed-build.client = {
        publicKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = ''
            SSH public key for root to connect to builders.
            Generate with: sudo ssh-keygen -t ed25519 -f /root/.ssh/nixremote -N ""
            Then set this to the contents of /root/.ssh/nixremote.pub
          '';
        };
        builders = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
          description = ''
            List of remote builders to use.
          '';
        };
      };

      config = {
        nix = {
          buildMachines =
            config.distributed-build.client.builders
            |> lib.map (builder: {
              inherit (builder)
                hostName
                systems
                maxJobs
                speedFactor
                supportedFeatures
                ;
              protocol = "ssh-ng";
              sshUser = "nixremote";
              sshKey = builder.identityFile;
            });
          distributedBuilds = true;
          extraOptions = ''
            builders-use-substitutes = true
          '';
        };
        programs.ssh.extraConfig =
          config.distributed-build.client.builders
          |> lib.concatMapStrings (builder: ''
            Host rustbucket
              HostName ${builder.host-ip}
              User nixremote
              IdentitiesOnly yes
              IdentityFile ${builder.identityFile}
              StrictHostKeyChecking accept-new
          '');
      };
    };
}
