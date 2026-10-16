{
  ...
}:
{
  # NVIDIA GPU driver for Wayland

  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        modesetting.enable = true; # Required for Wayland compositors
        powerManagement.enable = true; # Preserve GPU state across suspend/resume
        powerManagement.finegrained = false;
        open = true; # Open-source kernel modules (Turing+ GPUs)
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };

      # Hardware video acceleration
      hardware.graphics = {
        enable = true;
        enable32Bit = true; # For Steam and 32-bit games
      };

      # Environment variables for NVIDIA on Wayland
      environment.sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        NIXOS_OZONE_WL = "1"; # Electron apps on Wayland
        WLR_NO_HARDWARE_CURSORS = "0";
      };

      impermanence.ephemeralPaths = [
        "/etc/nvidia" # Generated config
        "/etc/egl" # EGL/OpenGL config
      ];
    };
}
