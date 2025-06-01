{
  config,
  lib,
  ...
}:

{
  config.home-manager.users.michael = {
    wayland.windowManager.sway = {
      enable = true;
    };
  };
}
