{ pkgs, ... }:

let
  # Credentials are decrypted by Home Manager's sops-nix service after login.
  mountOptions = credentials: [
    "credentials=${credentials}"
    "uid=1000"
    "gid=100"
    "forceuid"
    "forcegid"
    "file_mode=0600"
    "dir_mode=0700"
    "vers=3.1.1"
    "seal"
    "mfsymlinks"
    "cache=strict"
    "noserverino"
    "_netdev"
    "nofail"
    "x-systemd.automount"
    "x-systemd.idle-timeout=300"
    "x-systemd.mount-timeout=30s"
  ];
in
{
  environment.systemPackages = [ pkgs.cifs-utils ];

  fileSystems."/mnt/storagebox-stage" = {
    device = "//u399561.your-storagebox.de/backup";
    fsType = "cifs";
    options = mountOptions "/home/alex/.config/smb/storagebox-stage.credentials";
  };

  fileSystems."/mnt/storagebox-prod" = {
    device = "//u404406.your-storagebox.de/backup";
    fsType = "cifs";
    options = mountOptions "/home/alex/.config/smb/storagebox-prod.credentials";
  };
}
