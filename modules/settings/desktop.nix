{
  inputs,
  ...
}:
{
  # Common settings for graphical workstations

  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        default-settings
        systemd-boot
        keyboard-us
        wifi
        audio
        bluetooth
        cli
      ];

      xdg.portal.enable = true;
      programs.dconf.enable = true;
      security.polkit.enable = true;

      # Storage and disk management
      services.udisks2.enable = true;
      programs.fuse.userAllowOther = true;
      environment.systemPackages = with pkgs; [
        udiskie # Auto-mount helper
        exfatprogs # exFAT support
      ];

      impermanence.ephemeralPaths = [
        # Desktop environment
        "/etc/X11"
        "/etc/xdg"
        "/etc/polkit-1"
        "/etc/geoclue"
        "/etc/fonts"
        "/etc/speech-dispatcher"
        # Power management (UPower often pulled in by desktop deps)
        "/etc/UPower"
        "/var/lib/upower"
        "/var/lib/power-profiles-daemon"
        # Storage/disk management
        "/etc/udisks2"
        "/etc/fuse.conf"
        "/etc/libblockdev"
        "/etc/lvm"
        "/var/lib/udisks2"
      ];
    };
}
