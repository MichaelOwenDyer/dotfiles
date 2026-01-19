{
  inputs,
  ...
}:
{
  # Desktop environment - common settings for graphical workstations

  flake.modules.nixos.desktop =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        default-settings
        systemd-boot
        keyboard-us
        wifi
        audio
        bluetooth
      ];

      # Enable XDG desktop portal
      xdg.portal.enable = true;

      # Enable dconf for desktop application configuration
      programs.dconf.enable = true;

      # Enable PolicyKit for system-wide privilege management
      security.polkit.enable = true;
    };
}
