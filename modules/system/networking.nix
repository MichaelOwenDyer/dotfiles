{ config, lib, pkgs, ... }:

{
  ## DHCP needs to be enabled on a per-interface basis.
  ## This is part of the machine-specific configuration.
  networking.useDHCP = false;

  ## Enable network manager
  networking.networkmanager.enable = true;

  ## Enabling appropriate groups
  users.users.${config.username} = {
    extraGroups = [ "networkmanager" ]; 
  };

  ## Enable network manager applet
  home-manager.users.${config.username}.home.packages = with pkgs; [ networkmanagerapplet ];
}
