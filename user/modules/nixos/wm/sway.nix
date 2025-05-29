{
  config,
  lib,
  ...
}:

{
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      lib.mkIf (profile.windowManager == "sway") 
      {
        wayland.windowManager.sway = {
          enable = true;
        };
      }
    ) config.profiles;
  };
}
