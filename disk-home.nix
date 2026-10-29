{
  disko.devices.disk.sda = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7HENU0YA54327R";
    content = {
      type = "gpt";
      partitions = {
        windows-efi = { priority = 1; size = "100M"; type = "EF00"; };
        windows-msr = { priority = 2; size = "16M"; type = "0C01"; };
        windows = { priority = 3; size = "1428837M"; type = "0700"; };
        windows-recovery = { priority = 4; size = "914M"; type = "2700"; };
        ESP = {
          priority = 5;
          size = "1024M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
            extraArgs = [ "-n" "NIXOS-BOOT" ];
          };
        };
        root = {
          priority = 6;
          size = "476837M";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            extraArgs = [ "-L" "nixos" ];
          };
        };
      };
    };
  };
}
