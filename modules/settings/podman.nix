{
  ...
}:
{
  # Podman container runtime with Docker compatibility

  flake.modules.nixos.podman =
    { ... }:
    {
      virtualisation.podman = {
        enable = true;
        dockerSocket.enable = true; # Enable Docker socket for compatibility
      };
    };
}
