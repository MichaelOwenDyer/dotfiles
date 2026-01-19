{
  inputs,
  lib,
  ...
}:
{
  # Default settings needed for all nixosConfigurations

  flake.modules.nixos.default-settings = {
    imports = with inputs.self.modules.nixos; [
      overlays
      nh
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

      # Avoid copying unnecessary source files to the nix store
      # Benefit: Faster evaluations and less disk usage
      flake-registry = "";

      # Avoid downloading/updating the global flake registry
      # Benefit: Faster nix commands, explicit dependency management
      use-registries = false;
    };

    nix.extraOptions = ''
      warn-dirty = false
    '';

    # Automatic garbage collection to prevent disk bloat
    # Benefit: Keeps /nix/store from growing unbounded on long-running systems
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Localization defaults
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Berlin";
    console.font = "Lat2-Terminus16";

    # Enables unpatched dynamic binaries to run and find the libs they need
    # Benefit: Run pre-compiled binaries (e.g., from curl | sh installers) without patching
    programs.nix-ld.enable = true;

    # Disable nano as default editor
    programs.nano.enable = false;

    # Remove NixOS default EDITOR (let users set their own via home-manager)
    environment.variables.EDITOR = lib.mkForce null;

    # nftables is the modern packet filtering framework
    # Benefit: Replaces iptables with a cleaner, more performant implementation
    networking.nftables.enable = true;

    # dbus-broker is a high-performance, modern D-Bus implementation
    # Benefit: Lower latency, better security, reduced resource usage
    services.dbus.implementation = "broker";

    # Enable firmware updates via fwupd
    # Benefit: Keep hardware firmware current for security and compatibility
    services.fwupd.enable = lib.mkDefault true;

    # Increase inotify limits for file watchers (IDEs, build tools, etc.)
    # Benefit: Prevents "too many open files" errors in large projects
    boot.kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 1024;
    };
  };
}
