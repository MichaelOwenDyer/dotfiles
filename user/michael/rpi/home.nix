{
  pkgs,
  ...
}:

{
  imports = [
    (import ../common/home.nix { wayland = false; })
  ];
  
  home.stateVersion = "25.11";
}
