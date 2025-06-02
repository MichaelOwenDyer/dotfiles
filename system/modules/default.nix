# NixOS system modules

{
  lib,
  ...
}:

{
  imports = [
    ./audio.nix
    ./gaming.nix
    ./wifi.nix
    ./gnome-keyring.nix
  ];

  options.system.isLaptop = lib.mkEnableOption "laptop-specific functionality, such as brightness control";
}
