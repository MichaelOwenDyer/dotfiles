{
  enable,
}:

{
  lib,
  ...
}:

{
  home.sessionVariables = lib.mkIf enable {
    NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
  };
}