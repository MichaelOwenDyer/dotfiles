{
  ...
}:
{
  # Idle management with swayidle for Wayland sessions.
  # Uses DMS lock screen and niri display power control.

  flake.modules.homeManager.idle =
    { config, lib, pkgs, ... }:
    let
      cfg = config.services.idle;
      lockCmd = "${pkgs.systemd}/bin/loginctl lock-session";
      niri = config.programs.niri.package;
      displayOff = "${lib.getExe niri} msg action power-off-monitors";
    in
    {
      options.services.idle = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable idle management with swayidle";
        };

        displayTimeout = lib.mkOption {
          type = lib.types.int;
          description = ''
            Seconds of idle before turning off displays (0 to disable).
            Displays wake on any input without requiring a password.
          '';
        };

        lockTimeout = lib.mkOption {
          type = lib.types.int;
          description = ''
            Seconds of idle before locking the screen (0 to disable).
            After lock, password is required to continue.
          '';
        };

        lockBeforeSleep = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Lock screen before system sleep.
            Triggered by logind events like lid close or suspend command.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        services.swayidle = {
          enable = true;
          timeouts =
            (lib.optional (cfg.displayTimeout > 0) {
              timeout = cfg.displayTimeout;
              command = displayOff;
            })
            ++
            (lib.optional (cfg.lockTimeout > 0) {
              timeout = cfg.lockTimeout;
              command = lockCmd;
            });
          events = lib.mkIf cfg.lockBeforeSleep {
            before-sleep = lockCmd;
            lock = lockCmd;
          };
          extraArgs = [ ];
        };
      };
    };
}
