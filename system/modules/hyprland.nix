{
  pkgs,
  ...
}:

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
      xdg-desktop-portal-gtk  # Provides FileChooser, Settings, and other interfaces
    ];
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
        # Explicitly specify which portal handles which interface
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "gtk" ];
      };
    };
  };
}