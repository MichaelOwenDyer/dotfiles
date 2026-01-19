{
  ...
}:
{
  # Suspend-then-hibernate for laptops

  flake.modules.nixos.hibernate =
    { lib, ... }:
    {
      services.logind.settings.Login = {
        HandlePowerKey = lib.mkDefault "hibernate";
        HandlePowerKeyLongPress = lib.mkDefault "poweroff";
        HandleLidSwitch = lib.mkDefault "suspend-then-hibernate";
        IdleAction = lib.mkDefault "suspend-then-hibernate";
        IdleActionSec = lib.mkDefault "10min";
      };

      # Hibernate after 20 minutes of sleep
      systemd.sleep.extraConfig = ''
        HibernateDelaySec=20min
      '';
    };
}
