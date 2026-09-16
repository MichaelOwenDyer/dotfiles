{
  inputs,
  ...
}:
{
  # Default settings for all NixOS configurations

  flake.modules.nixos.default-settings =
    { pkgs, lib, ... }:
    {
      key = "modules/defaults/nixos-default.nix";

      # Set git revision for `nixos-rebuild list-generations`
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      imports = with inputs.self.modules.nixos; [
        impermanence-options # Enable modules to declare impermanence config
        overlays
        nix-settings
        locale
        security-defaults
        bash-shell
        nh
        sops
      ];

      environment.systemPackages = [ pkgs.uutils-coreutils-noprefix ];

      # Allow running unpatched dynamic binaries (e.g., from curl | sh installers)
      programs.nix-ld.enable = true;

      # Clear NixOS default editor so users can set their own via home-manager
      programs.nano.enable = false;
      environment.variables.EDITOR = lib.mkForce null;

      # Firmware updates via fwupd
      services.fwupd.enable = lib.mkDefault true;

      services.speechd.enable = false;

      # Increase inotify limits for IDEs and build tools watching large projects
      boot.kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 1024;
      };

      impermanence.persistedDirectories = [
        "/var/lib/systemd/rfkill" # Radio kill switch state
        "/var/lib/systemd/timers" # Persistent timer state
        "/var/lib/systemd/timesync" # NTP state
      ];

      impermanence.ephemeralPaths = [
        "/etc/fwupd"
        "/var/lib/fwupd"
        "/var/lib/dnsmasq"
      ];
    };
}
