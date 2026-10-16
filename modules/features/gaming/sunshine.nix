{
  ...
}:
{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
    };

    systemd.user.services.sunshine.serviceConfig = {
      Environment = [
        "WAYLAND_DISPLAY="
        "DISPLAY=:0"
        "__NV_PRIME_RENDER_OFFLOAD=1"
      ];
    };
  };
}
