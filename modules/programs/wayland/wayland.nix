{
  inputs,
  ...
}:
{
  # Wayland environment variables

  flake.modules.homeManager.wayland-env = {
    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      GTK_USE_PORTAL = "1";
    };
  };
}
