{
  ...
}:
{
  # NVIDIA GPU configuration - optimized for Wayland and performance

  flake.modules.nixos.nvidia =
    { config, ... }:
    {
      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        # Required for most Wayland compositors (Niri, Hyprland, etc.)
        # Benefit: Proper display output and vsync
        modesetting.enable = true;

        # Save/restore GPU state on suspend/resume
        # Benefit: Prevents graphical corruption after sleep
        powerManagement.enable = true;

        # Fine-grained power management (for laptops with NVIDIA Optimus)
        # Disabled here as this is for a desktop
        powerManagement.finegrained = false;

        # Use open-source kernel modules (supported on Turing+, GTX 16xx/RTX 20xx+)
        # Benefit: Better maintained, required for some features like GSP firmware
        open = true;

        # Install nvidia-settings GUI
        nvidiaSettings = true;

        # Use latest driver for newest features and fixes
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };

      # Hardware acceleration for video decode/encode
      # Benefit: GPU-accelerated video playback, reduces CPU usage
      hardware.graphics = {
        enable = true;
        enable32Bit = true; # For 32-bit games/apps (Steam)
      };

      # Environment variables for NVIDIA + Wayland
      # Benefit: Ensures apps use correct GPU and Wayland backend
      environment.sessionVariables = {
        # Force GBM backend for Wayland (required for some apps)
        GBM_BACKEND = "nvidia-drm";
        # Tell libva to use nvidia driver
        LIBVA_DRIVER_NAME = "nvidia";
        # Needed for Electron apps on Wayland
        NIXOS_OZONE_WL = "1";
        # Use hardware cursors (can be disabled if cursor flickers)
        WLR_NO_HARDWARE_CURSORS = "0";
      };
    };
}
