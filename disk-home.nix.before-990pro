{
  disko.devices = {
    # Keep this name: disko derives the existing disk-sda-* partition labels from it.
    disk.sda = {
      type = "disk";
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B77831341A1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
              extraArgs = [
                "-n"
                "NIXOS-BOOT"
              ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              extraArgs = [
                "-L"
                "nixos"
              ];
            };
          };
        };
      };
    };
  };
}
