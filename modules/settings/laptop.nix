{
  inputs,
  ...
}:
{
  # Laptop configuration - extends desktop with laptop-specific settings

  flake.modules.nixos.laptop =
    { lib, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        desktop
        touchpad
        hibernate
      ];

      # Use powersave governor by default on laptops
      # Benefit: Significantly extends battery life
      powerManagement.cpuFreqGovernor = "powersave";

      # Reduce wifi scanning on low signal to save battery
      # Benefit: Prevents constant scanning drain when signal is weak
      networking.wireless.scanOnLowSignal = false;

      # Enable TLP for advanced power management
      # Benefit: Automatic power profiles, battery charge thresholds, device power saving
      services.tlp = {
        enable = true;
        settings = {
          # Battery charge thresholds (if supported by hardware)
          # Benefit: Extends battery lifespan by avoiding 100% charge
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;

          # CPU scaling on battery
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";

          # Reduce turbo boost on battery
          # Benefit: Lower power consumption, less heat
          CPU_BOOST_ON_BAT = 0;
          CPU_BOOST_ON_AC = 1;

          # WiFi power saving
          WIFI_PWR_ON_BAT = "on";
          WIFI_PWR_ON_AC = "off";

          # USB autosuspend (may need exceptions for some devices)
          USB_AUTOSUSPEND = 1;

          # PCIe ASPM (Active State Power Management)
          # Benefit: Significant power savings for PCIe devices
          PCIE_ASPM_ON_BAT = "powersupersave";
          PCIE_ASPM_ON_AC = "default";
        };
      };

      # Disable power-profiles-daemon (conflicts with TLP)
      services.power-profiles-daemon.enable = lib.mkForce false;

      # Enable thermald for Intel CPUs
      # Benefit: Prevents thermal throttling, extends hardware life
      services.thermald.enable = true;
    };
}
