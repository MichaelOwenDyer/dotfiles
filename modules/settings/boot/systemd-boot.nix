{
  ...
}:
{
  # systemd-boot bootloader configuration - secure and optimized

  flake.modules.nixos.systemd-boot =
    { lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

        loader = {
          # Skip boot menu by default (press key to show)
          # Benefit: Faster boot, menu available when needed
          timeout = lib.mkDefault 0;

          systemd-boot = {
            enable = true;

            # Limit stored generations to prevent /boot from filling up
            # Benefit: EFI partitions are small; prevents boot failures
            configurationLimit = lib.mkDefault 7;

            # Disable kernel command line editing at boot
            # Benefit: Prevents single-user mode access without password
            editor = false;

            # Use high-resolution console for boot messages
            # Benefit: Readable text on HiDPI displays
            consoleMode = "auto";
          };

          efi.canTouchEfiVariables = true;
        };

        # Clean /tmp on boot
        # Benefit: Prevents /tmp bloat, ensures clean state
        tmp.cleanOnBoot = true;

        # Silent boot defaults (plymouth module may override with stricter settings)
        # Benefit: Cleaner boot experience, errors still logged to journal
        consoleLogLevel = lib.mkDefault 3;
        initrd.verbose = lib.mkDefault false;
        kernelParams = lib.mkDefault [
          "quiet"
          "udev.log_level=3"
        ];
      };
    };
}
