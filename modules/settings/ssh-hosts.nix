{
  inputs,
  ...
}:
{
  # SSH host aliases: ssh michael@rustbucket, ssh michael@rustbucket-home, etc.

  flake.modules.nixos.ssh-client-hosts =
    { lib, config, ... }:
    let
      inherit (inputs.self.lib) hosts sshKeys;
      userKey = sshKeys."michael@${config.networking.hostName}" or null;

      mkHostConfig = name: host:
        let
          baseConfig = ''
            User michael
            ${lib.optionalString (userKey != null) "IdentityFile ${userKey.privatePath}"}
            StrictHostKeyChecking accept-new
            ControlMaster auto
            ControlPath ~/.ssh/sockets/%r@%h-%p
            ControlPersist 600
          '';
        in
        lib.optionalString (host.networks.tailscale.ipv4 or null != null) ''
          Host ${name} ${name}-tailscale
            HostName ${host.networks.tailscale.ipv4}
            ${baseConfig}
        ''
        + lib.optionalString (host.networks.home.ipv4 or null != null) ''
          Host ${name}-home
            HostName ${host.networks.home.ipv4}
            ${baseConfig}
        ''
        + lib.optionalString (host.networks.streaming.ipv4 or null != null) ''
          Host ${name}-streaming
            HostName ${host.networks.streaming.ipv4}
            ${baseConfig}
        '';

      otherHosts = lib.filterAttrs (n: h: n != config.networking.hostName && h.system != null) hosts;
    in
    {
      programs.ssh.extraConfig = lib.concatStrings (lib.mapAttrsToList mkHostConfig otherHosts);

      system.activationScripts.sshUserSocketDir = ''
        for dir in /home/*; do
          [ -d "$dir" ] && mkdir -p "$dir/.ssh/sockets" && chown "$(basename "$dir")" "$dir/.ssh/sockets" 2>/dev/null || true
        done
      '';
    };

  flake.modules.homeManager.ssh-client-hosts =
    { lib, osConfig, ... }:
    let
      inherit (inputs.self.lib) hosts;
      currentHost = osConfig.networking.hostName or "";

      mkMatchBlocks = name: host:
        let base = { user = "michael"; }; in
        lib.optionalAttrs (host.networks.tailscale.ipv4 or null != null) {
          ${name} = base // { hostname = host.networks.tailscale.ipv4; };
          "${name}-tailscale" = base // { hostname = host.networks.tailscale.ipv4; };
        }
        // lib.optionalAttrs (host.networks.home.ipv4 or null != null) {
          "${name}-home" = base // { hostname = host.networks.home.ipv4; };
        }
        // lib.optionalAttrs (host.networks.streaming.ipv4 or null != null) {
          "${name}-streaming" = base // { hostname = host.networks.streaming.ipv4; };
        };

      otherHosts = lib.filterAttrs (n: h: n != currentHost && h.system != null) hosts;
    in
    {
      programs.ssh = {
        enable = true;
        matchBlocks = lib.foldl' (acc: n: acc // mkMatchBlocks n hosts.${n}) { } (lib.attrNames otherHosts);
        controlPath = "~/.ssh/sockets/%r@%h-%p";
        controlMaster = "auto";
        controlPersist = "10m";
      };
      home.file.".ssh/sockets/.keep".text = "";
    };
}
