{
  inputs,
  ...
}:
{
  # Laptop configuration - extends desktop with laptop-specific settings

  flake.modules.nixos.laptop =
    { ... }:
    {
      imports = with inputs.self.modules.nixos; [
        desktop
        touchpad
        hibernate
      ];

      # Use powersave governor by default on laptops
      powerManagement.cpuFreqGovernor = "powersave";

      # Reduce wifi scanning on low signal to save battery
      networking.wireless.scanOnLowSignal = false;
    };
}
