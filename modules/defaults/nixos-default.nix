{
  inputs,
  ...
}:
{
  # Default settings for all NixOS configurations

  flake.modules.nixos.default-settings =
    { lib, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        overlays
        nh
        sops
        # Enable modules to declare impermanence config regardless of whether impermanence is used
        impermanence-options
      ];

      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];

        # Disable the global flake registry for faster commands and explicit dependencies
        flake-registry = "";
        use-registries = false;
      };

      nix.extraOptions = ''
        warn-dirty = false
      '';

      # Garbage collection is handled by nh clean (see modules/features/nh/nh.nix)

      # Localization
      i18n.defaultLocale = "en_US.UTF-8";
      time.timeZone = "Europe/Berlin";
      console.font = "Lat2-Terminus16";

      # Allow running unpatched dynamic binaries (e.g., from curl | sh installers)
      programs.nix-ld.enable = true;

      # Clear NixOS default editor so users can set their own via home-manager
      programs.nano.enable = false;
      environment.variables.EDITOR = lib.mkForce null;

      # Modern alternatives to legacy subsystems
      networking.nftables.enable = true; # Replaces iptables
      services.dbus.implementation = "broker"; # Faster, more secure D-Bus

      # Firmware updates via fwupd
      services.fwupd.enable = lib.mkDefault true;

      # Increase inotify limits for IDEs and build tools watching large projects
      boot.kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 1024;
      };

      # Impermanence: fwupd and systemd state
      impermanence.persistedDirectories = [
        "/var/lib/systemd/rfkill" # Radio kill switch state
        "/var/lib/systemd/timers" # Persistent timer state
        "/var/lib/systemd/timesync" # NTP state
      ];
      impermanence.ignoredPaths = [
        "/etc/fwupd" # fwupd config - regenerated
        "/var/lib/fwupd" # Firmware cache - regenerated
        "/var/lib/dnsmasq" # DNS cache
        "/var/lib/nftables" # Firewall state - regenerated
        "/var/lib/power-profiles-daemon"
        "/var/lib/upower"
        "/var/lib/udisks2"
      ];
    };
}
