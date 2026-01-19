{
  ...
}:
{
  # Hibernate and suspend-then-hibernate configuration
  # Suitable for laptops that should hibernate after extended sleep

  flake.modules.nixos.hibernate =
    { lib, ... }:
    {
      # Power button and lid switch behavior
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
