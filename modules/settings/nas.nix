{
  inputs,
  ...
}:
{
  # NAS Feature Module - Unified Google Drive replacement
  # Combines FileBrowser Quantum (Web UI over Tailscale HTTPS), Samba (SMB native drive), and Tailscale Proxy

  flake.modules.nixos.nas =
    { lib, config, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        samba
        filebrowser-quantum
        tailscale-proxy
      ];

      options.nas = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the target storage volume";
        };
        targetDir = lib.mkOption {
          type = lib.types.path;
          description = "Root directory of the target storage volume";
        };
        mountUnit = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional systemd mount unit dependency (e.g. 'mnt-nas.mount')";
        };
        web.urlPath = lib.mkOption {
          type = lib.types.str;
          description = "URL path for FileBrowser Quantum in Tailscale HTTPS proxy";
        };
        smb.guestAccess = lib.mkOption {
          type = lib.types.bool;
          description = "Allow guest access to SMB without password";
        };
      };

      config =
        let
          cfg = config.nas;
        in
        {
          filebrowser-quantum = {
            name = cfg.name;
            targetDir = cfg.targetDir;
            mountUnit = cfg.mountUnit;
            urlPath = cfg.web.urlPath;
          };

          samba = {
            shares."${cfg.name}" = {
              path = cfg.targetDir;
              guestOk = cfg.smb.guestAccess;
              forceUser = "filebrowser";
              forceGroup = "users";
            };
          };
        };
    };
}
