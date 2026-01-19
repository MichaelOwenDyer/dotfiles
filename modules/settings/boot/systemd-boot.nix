{
  ...
}:
{
  # systemd-boot configuration

  flake.modules.nixos.systemd-boot =
    { lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

        loader = {
          timeout = lib.mkDefault 0; # Skip menu by default, press key to show
          systemd-boot = {
            enable = true;
            configurationLimit = lib.mkDefault 7; # Prevent /boot from filling up
            editor = false; # Disable kernel cmdline editing for security
            consoleMode = "auto"; # High-res console for HiDPI displays
          };
          efi.canTouchEfiVariables = true;
        };

        tmp.cleanOnBoot = true;

        # Silent boot (plymouth may override with stricter settings)
        consoleLogLevel = lib.mkDefault 3;
        initrd.verbose = lib.mkDefault false;
        kernelParams = lib.mkDefault [
          "quiet"
          "udev.log_level=3"
        ];
      };
    };
}
