{ config, lib, pkgs, ... }:

{
  config = {  
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false; # Set true to open ports in the firewall for Steam Remote Play
    };
  };
}