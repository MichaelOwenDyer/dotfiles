{
  ...
}:
{
  # Podman with Docker socket compatibility

  flake.modules.nixos.podman =
    { ... }:
    {
      virtualisation.podman = {
        enable = true;
        dockerSocket.enable = true;
      };

      impermanence.persistedDirectories = [
        "/var/lib/containers" # Container images and state
      ];
    };
}
