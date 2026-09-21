{ config, pkgs, ... }:

{
  programs.zsh.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if ((action.id == "org.freedesktop.policykit.exec" || action.id == "org.freedesktop.systemd1.manage-units") &&
        subject.user == "alex") {
          return polkit.Result.YES;
      }
    });
  '';

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
