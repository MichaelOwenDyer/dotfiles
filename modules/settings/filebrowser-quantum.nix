{
  ...
}:
{
  # FileBrowser Quantum - Web-based file manager daemon
  # https://github.com/gtsteffaniak/filebrowser

  flake.modules.nixos.filebrowser-quantum =
    { pkgs, lib, config, ... }:
    let
      cfg = config.filebrowser-quantum;
      workingDirectory = "/var/lib/filebrowser-quantum";
      configFile = pkgs.writeText "filebrowser-quantum.yaml" (lib.generators.toYAML { } {
        server = {
          port = cfg.port;
          listen = cfg.listenAddress;
          baseURL = cfg.urlPath;
          sources = [
            {
              name = cfg.name;
              path = cfg.targetDir;
            }
          ];
        };
        database = cfg.database;
      });
    in
    {
      options.filebrowser-quantum = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the storage source in FileBrowser Quantum";
        };
        targetDir = lib.mkOption {
          type = lib.types.path;
          description = "Target storage directory";
        };
        mountUnit = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional systemd mount unit dependency (e.g. 'mnt-nas.mount')";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 8088;
          description = "Internal port for FileBrowser Quantum web UI";
        };
        listenAddress = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address to bind FileBrowser Quantum to";
        };
        urlPath = lib.mkOption {
          type = lib.types.str;
          description = "URL path location for Tailscale HTTPS proxy";
        };
        database = lib.mkOption {
          type = lib.types.path;
          default = "${workingDirectory}/database.db";
          description = "Path to database file";
        };
      };

      config = {
        tailscale-proxy.proxiedServices.filebrowser-quantum = {
          path = cfg.urlPath;
          forwardTo = "http://${cfg.listenAddress}:${toString cfg.port}";
          proxyWebsockets = true;
          maxBodySize = null;
        };

        systemd.services.filebrowser-quantum = {
          description = "FileBrowser Quantum";
          after = [ "network.target" ] ++ lib.optional (cfg.mountUnit != null) cfg.mountUnit;
          wants = lib.optional (cfg.mountUnit != null) cfg.mountUnit;
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${pkgs.filebrowser-quantum}/bin/filebrowser-quantum -c ${configFile}";
            User = "filebrowser";
            Group = "users";
            UMask = "0002";
            StateDirectory = "filebrowser-quantum";
            WorkingDirectory = workingDirectory;
            Restart = "always";
            RestartSec = "5s";
          };
        };

        users.users.filebrowser = {
          isSystemUser = true;
          group = "users";
        };
      };
    };
}
