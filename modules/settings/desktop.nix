{
  inputs,
  ...
}:
{
  # Common settings for graphical workstations

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
        cli
      ];

      xdg.portal.enable = true;
      programs.dconf.enable = true;
      security.polkit.enable = true;
    };
}
