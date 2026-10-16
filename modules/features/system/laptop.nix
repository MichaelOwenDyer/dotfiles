{
  inputs,
  ...
}:
{
  # Laptop-specific settings: power management, touchpad, hibernate

  flake.modules.nixos.laptop =
    { lib, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        desktop
        touchpad
        hibernate
      ];

      powerManagement.cpuFreqGovernor = "powersave";
      networking.wireless.scanOnLowSignal = false; # Save battery

      # TLP for advanced power management
      services.tlp = {
        enable = true;
        settings = {
          # Battery charge thresholds to extend battery lifespan
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;

          # CPU governor per power state
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";

          # Disable turbo boost on battery
          CPU_BOOST_ON_BAT = 0;
          CPU_BOOST_ON_AC = 1;

          # WiFi power saving
          WIFI_PWR_ON_BAT = "on";
          WIFI_PWR_ON_AC = "off";

          USB_AUTOSUSPEND = 1;

          # PCIe Active State Power Management
          PCIE_ASPM_ON_BAT = "powersupersave";
          PCIE_ASPM_ON_AC = "default";
        };
      };

      services.power-profiles-daemon.enable = lib.mkForce false; # Conflicts with TLP
      services.thermald.enable = true; # Thermal management for Intel CPUs
    };
}
