{
  ...
}:
{
  # systemd-boot bootloader configuration

  flake.modules.nixos.systemd-boot =
    { lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        loader = {
          timeout = lib.mkDefault 0;
          systemd-boot = {
            enable = true;
            configurationLimit = lib.mkDefault 7;
            editor = false; # Disable editor for security
          };
          efi.canTouchEfiVariables = true;
        };
      };
    };
}
