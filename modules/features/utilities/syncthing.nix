{ ... }:
let
  guiPort = 8384;
  transferPort = 22000;
  discoveryPort = 21027;
in
{

  flake.modules.nixos.syncthing = {
    networking.firewall = {
      allowedTCPPorts = [ transferPort ];
      allowedUDPPorts = [ transferPort discoveryPort ];
    };
  };

  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      enable = true;
      guiAddress = "localhost:${toString guiPort}";
      tray.enable = true;
    };
  };
}
