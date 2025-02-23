# Configuration for my 2018 Intel i9 MacBook Pro

_:

{
  imports = [
    # Common macOS machine configuration
    ./default.nix
    # Add michael as a user
    ../../../user/profiles/michael/macaroni.nix
  ];

  # Let Determinate Nix handle the nix installation
  nix.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
