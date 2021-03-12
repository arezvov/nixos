{ config, ... }:

{
  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "video" "adbusers" "libvirtd" "qemu-libvirtd" ];
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      alex ALL=NOPASSWD: ALL
    '';
  };
}
