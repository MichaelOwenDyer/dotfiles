{ ... }:
{
  # Distributed build client - offloads builds to remote builders

  flake.modules.nixos.distributed-build-client =
    { lib, config, ... }:
    let
      cfg = config.distributed-build-client;
      builderSshAlias = builder: "${builder.hostName}-${builder.network}";
    in
    {
      options.distributed-build-client = {
        rootSshKey.pub = lib.mkOption {
          type = lib.types.str;
        };
        rootSshKey.privatePath = lib.mkOption {
          type = lib.types.oneOf [ lib.types.path lib.types.str ];
        };
        builders = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
        };
        fallbackToLocal = lib.mkOption {
          type = lib.types.bool;
          default = true;
        };
      };

      config = {
        nix = {
          distributedBuilds = true;
          extraOptions = "builders-use-substitutes = true";

          buildMachines = cfg.builders |> lib.map (builder: {
            hostName = builderSshAlias builder;
            inherit (builder) systems maxJobs speedFactor supportedFeatures protocol sshUser;
            sshKey = cfg.rootSshKey.privatePath;
          });

          settings = {
            fallback = cfg.fallbackToLocal;
            connect-timeout = 5;
            stalled-download-timeout = 30;
            substituters = cfg.builders
              |> lib.filter (b: b.signingKey or null != null)
              |> lib.map (b: "ssh-ng://nixremote@${builderSshAlias b}")
              |> lib.unique;
            trusted-public-keys = cfg.builders
              |> lib.filter (b: b.signingKey or null != null)
              |> lib.map (b: b.signingKey)
              |> lib.unique;
          };
        };

        system.activationScripts.sshSocketDir = ''
          mkdir -p /root/.ssh/sockets && chmod 700 /root/.ssh/sockets
        '';

        programs.ssh.extraConfig = cfg.builders |> lib.concatMapStrings (builder: ''
          Host ${builderSshAlias builder}
            HostName ${builder.host-ipv4}
            User ${builder.sshUser}
            IdentitiesOnly yes
            IdentityFile ${cfg.rootSshKey.privatePath}
            StrictHostKeyChecking accept-new
            ControlMaster auto
            ControlPath /root/.ssh/sockets/%r@%h-%p
            ControlPersist 60
            ConnectTimeout 5
            ServerAliveInterval 15
            ServerAliveCountMax 3
        '');
      };
    };
}
