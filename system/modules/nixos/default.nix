# NixOS system modules

_:

{
  imports = [
    # Import default system modules, options, and configuration
    ../default.nix
    # NixOS system modules
    ./audio.nix
    ./gaming.nix
    ./wifi.nix
		./stylix.nix
  ];
}
