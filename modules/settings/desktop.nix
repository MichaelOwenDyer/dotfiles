{
  inputs,
  ...
}:
{
  # Desktop environment

  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        wifi
        audio
        bluetooth
      ];

      # Enable XDG desktop portal
      xdg.portal.enable = true;
      # Enable dconf, a configuration system used by many desktop applications
      programs.dconf.enable = true;
      # Enable PolicyKit for managing system-wide privileges
      security.polkit.enable = true;
    };
}
