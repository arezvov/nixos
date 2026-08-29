{ config, pkgs, ... }:

let
  homeDirectory = config.home.homeDirectory;

  excludeFile = pkgs.writeText "restic-home-excludes" ''
    ${homeDirectory}/.cache
    ${homeDirectory}/.local/share/Trash
    ${homeDirectory}/.npm/_cacache
    ${homeDirectory}/.cargo/registry/cache
    ${homeDirectory}/.cargo/git/db
    ${homeDirectory}/.gradle/caches
    ${homeDirectory}/.m2/repository
    ${homeDirectory}/github/nixpkgs
    ${homeDirectory}/.codex
  '';

  backupHome = pkgs.writeShellScript "restic-backup-home" ''
    set -eu

    if ! ${pkgs.restic}/bin/restic cat config >/dev/null 2>&1; then
      ${pkgs.restic}/bin/restic init
    fi

    ${pkgs.restic}/bin/restic backup "${homeDirectory}" \
      --one-file-system \
      --exclude-caches \
      --exclude-file=${excludeFile}
  '';
in
{
  home.packages = [ pkgs.restic ];

  systemd.user.services.restic-backup-home = {
    Unit = {
      Description = "Back up the home directory to Cloud.ru Object Storage";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      EnvironmentFile = "%h/.config/restic/s3.env";
      ExecStart = backupHome;
    };
  };

  systemd.user.timers.restic-backup-home = {
    Unit.Description = "Daily home directory backup";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
