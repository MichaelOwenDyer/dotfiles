{
  ...
}:
{
  # Plymouth boot splash - configurable theme

  flake.modules.nixos.plymouth =
    { pkgs, lib, ... }:
    {
      boot.plymouth = {
        enable = true;
        theme = lib.mkDefault "colorful_sliced";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "colorful_sliced" ];
          })
        ];
      };
      boot.consoleLogLevel = 0;
      boot.initrd.verbose = false;
      boot.kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];

      # Impermanence: plymouth state is ephemeral
      impermanence.ephemeralPaths = [ "/var/lib/plymouth" ];
    };
}
