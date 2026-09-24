{
  inputs,
  ...
}:
{
  # Samba / SMB file sharing server infrastructure module

  flake.modules.nixos.samba =
    { lib, config, ... }:
    let
      cfg = config.samba;
    in
    {
      options.samba = {
        shares = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                path = lib.mkOption {
                  type = lib.types.path;
                  description = "Path to share";
                };
                readOnly = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Read-only access";
                };
                guestOk = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Allow guest access without password";
                };
                forceUser = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Force UNIX user for file access";
                };
                forceGroup = lib.mkOption {
                  type = lib.types.str;
                  default = "users";
                  description = "Force UNIX group for file access";
                };
                createMask = lib.mkOption {
                  type = lib.types.str;
                  default = "0664";
                  description = "Default file creation mask";
                };
                directoryMask = lib.mkOption {
                  type = lib.types.str;
                  default = "0775";
                  description = "Default directory creation mask";
                };
              };
            }
          );
          default = { };
          description = "Declarative Samba shares";
        };
      };

      config = {
        services.samba = {
          enable = true;
          openFirewall = true;
          settings = {
            global = {
              "workgroup" = "WORKGROUP";
              "server string" = "${config.networking.hostName} NAS";
              "netbios name" = config.networking.hostName;
              "security" = "user";
              "hosts allow" = "100.0.0.0/8 192.168.1.0/24 127.0.0.1 ::1";
              "hosts deny" = "0.0.0.0/0";
              "guest account" = "nobody";
              "map to guest" = "bad user";
            };
          } // (
            cfg.shares
            |> lib.mapAttrs (
              _name: share:
              {
                "path" = share.path;
                "browseable" = "yes";
                "read only" = if share.readOnly then "yes" else "no";
                "guest ok" = if share.guestOk then "yes" else "no";
                "public" = if share.guestOk then "yes" else "no";
                "create mask" = share.createMask;
                "directory mask" = share.directoryMask;
                "force group" = share.forceGroup;
              }
              // (lib.optionalAttrs (share.forceUser != null) {
                "force user" = share.forceUser;
              })
            )
          );
        };

        services.samba-wsdd = {
          enable = true;
          openFirewall = true;
        };

        impermanence.persistedDirectories = [
          "/var/lib/samba"
        ];
      };
    };
}
