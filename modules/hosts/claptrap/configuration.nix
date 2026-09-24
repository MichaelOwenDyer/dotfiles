{
  inputs,
  ...
}:
{
  # Dell XPS 13 9360 laptop (temporarily also acting as single-arm router)

  flake.modules.nixos.claptrap =
    { ... }:
    let
      wifiInterface = "wlp58s0";
      tailscaleInterface = "tailscale0";
    in
    {
      imports = with inputs.self.modules.nixos; [
        claptrap-hardware
        laptop
        ly
        niri
        dank-material-shell
        tailscale
        nas
        plymouth
        ssh
        ssh-client-hosts
        distributed-build-client
        michael-claptrap
        router
      ];

      networking.hostName = "claptrap";

      router.trunkInterface = "enp0s20f0u2";
      router.trustedInterfaces = [ wifiInterface tailscaleInterface ];

      nas = {
        name = "nas";
        targetDir = "/mnt/nas";
        mountUnit = "mnt-nas.mount";
        web.urlPath = "/filebrowser";
        smb.guestAccess = true;
      };
      fileSystems."/mnt/nas" = {
        device = "/dev/disk/by-id/usb-Genki_Genki_SavePoint_012345678934-0:0-part1";
        fsType = "btrfs";
        options = [
          "nofail"
          "x-systemd.automount"
          "compress=zstd"
        ];
      };
      systemd.tmpfiles.rules = [
        "d /mnt/nas 2775 filebrowser users - -"
        "z /mnt/nas 2775 filebrowser users - -"
      ];

      distributed-build-client = {
        rootSshKey = inputs.self.lib.distributedBuild.clients.claptrap.rootSshKey;
        builders = with inputs.self.lib.distributedBuild.builders; [
          rustbucket-home
        ];
      };

      users.users.root.openssh.authorizedKeys.keys = [
        inputs.self.lib.sshKeys."michael@rustbucket".pub
      ];

      system.stateVersion = "24.11";
    };
}
