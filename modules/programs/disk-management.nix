{
  ...
}:
{
  flake.modules.nixos.disk-management =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gparted # Partition editor
#        lvm2 # Logical volume management
#        cryptsetup # LUKS encryption
#        dosfstools # FAT and VFAT filesystems
#        ntfs3g # NTFS filesystem
#        btrfs-progs # Btrfs filesystem tools
#        lz4 # Compression tool often used with Btrfs
      ];
    };
}