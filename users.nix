{ config, pkgs, ... }:

{
  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "audio" "video" "adbusers" "libvirtd" "qemu-libvirtd" "incus-admin" ];
    shell = pkgs.zsh;
  };

  security.sudo = {
    enable = true;
    extraConfig = ''
      alex ALL=NOPASSWD: ALL
    '';
  };
}
