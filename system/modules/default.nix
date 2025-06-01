# NixOS system modules

_:

{
  imports = [
    ./audio.nix
    ./gaming.nix
    ./wifi.nix
    ./gnome-keyring.nix
  ];
}
