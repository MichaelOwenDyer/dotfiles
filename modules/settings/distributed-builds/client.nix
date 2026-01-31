{
  ...
}:
{
  # Base distributed build client module
  # Host-specific client modules (client-rustbucket, client-mac) import this

  flake.modules.nixos.distributed-build-client =
    { lib, config, ... }:
    let
      cfg = config.distributed-build.client;
    in
    {
      options.distributed-build.client = {
        rootSshKey.pub = lib.mkOption {
          type = lib.types.str;
          description = ''
              The content of the SSH public key corresponding to the private key at rootSshKey.privatePath.
            '';
        };
        rootSshKey.privatePath = lib.mkOption {
          type = lib.types.oneOf [ lib.types.path lib.types.str ];
          description = ''
              The path to an SSH private key on the client, owned by root, without passphrase.
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
          distributedBuilds = true;
          buildMachines =
            cfg.builders
            |> lib.map (builder: {
              inherit (builder)
                hostName
                systems
                maxJobs
                speedFactor
                supportedFeatures
                protocol
                sshUser
                ;
              sshKey = cfg.rootSshKey.privatePath;
            });
          # Allow builders to also pull from binary caches instead of building from source  
          extraOptions = ''
            builders-use-substitutes = true
          '';
          settings = {
            # The client can also download precompiled binaries from the builder provided they are signed
            substituters =
              config.distributed-build.client.builders
              |> lib.filter (builder: builder.signingKey or null != null)
              |> lib.map (builder: "ssh-ng://nixremote@${builder.hostName}?compress=false");
            # The GPG public signing keys of the builders to validate downloaded artifacts
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

        # Ensure builders are listed in /etc/ssh/ssh_known_hosts
        programs.ssh.extraConfig =
          config.distributed-build.client.builders
          |> lib.concatMapStrings (builder: ''
            Host ${builder.hostName}
              HostName ${builder.host-ip}
              User ${builder.sshUser}
              IdentitiesOnly yes
              IdentityFile ${cfg.rootSshKey.privatePath}
              StrictHostKeyChecking accept-new
              ControlMaster auto
              ControlPath /root/.ssh/sockets/%r@%h-%p
              ControlPersist 60
          '');
      };
    };
}
