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
          '';
        };
        builders = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
          description = ''
            List of remote builders to use.
            If a builder has a signingKey attribute, it will also be used as a substituter.
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
          settings = {
            substituters =
              config.distributed-build.client.builders
              |> lib.filter (builder: builder.signingKey or null != null)
              |> lib.map (builder: "ssh-ng://nixremote@${builder.hostName}?compress=false");
            trusted-public-keys =
              config.distributed-build.client.builders
              |> lib.filter (builder: builder.signingKey or null != null)
              |> lib.map (builder: builder.signingKey);
          };
        };
        # Ensure socket directory exists for SSH multiplexing
        system.activationScripts.sshSocketDir = ''
          mkdir -p /root/.ssh/sockets
          chmod 700 /root/.ssh/sockets
        '';

        programs.ssh.extraConfig =
          config.distributed-build.client.builders
          |> lib.concatMapStrings (builder: ''
            Host ${builder.hostName}
              HostName ${builder.host-ip}
              User nixremote
              IdentitiesOnly yes
              IdentityFile ${builder.identityFile}
              StrictHostKeyChecking accept-new
              ControlMaster auto
              ControlPath /root/.ssh/sockets/%r@%h-%p
              ControlPersist 60
          '');
      };
    };
}
