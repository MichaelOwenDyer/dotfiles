{
  pkgs,
  ...
}:

{
  # Enable the X11 windowing system (and implicitly Wayland).
  services.xserver.enable = true;
  # Allow X applications to run on wayland via an adapter
  programs.xwayland.enable = true;
  # Enable hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}