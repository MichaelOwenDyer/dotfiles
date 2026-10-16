{
  ...
}:
{
  # Hyprland window manager

  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      services.displayManager.sessionPackages = [ pkgs.hyprland ];
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
        ];
        config = {
          hyprland = {
            default = [
              "hyprland"
              "gtk"
            ];
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
            "org.freedesktop.impl.portal.Secret" = [ "gtk" ];
          };
        };
      };
    };
}
