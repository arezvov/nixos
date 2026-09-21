{ config, lib, pkgs, ... }:

let
  homeDirectory = config.home.homeDirectory;
  backupDirectories = [
    "${homeDirectory}/Documents"
    "${homeDirectory}/work"
  ];

  # Only ciphertext enters the Nix store; exports are generated at runtime.
  resticEnv = pkgs.writeShellScript "restic-env" ''
    set -euo pipefail
    export GNUPGHOME=${lib.escapeShellArg config.sops.gnupg.home}
    export SOPS_GPG_EXEC=${pkgs.gnupg}/bin/gpg
    ${pkgs.sops}/bin/sops decrypt --output-type json ${../secrets/restic-s3.json} |
      ${pkgs.jq}/bin/jq -er '
        if type == "object" and all(to_entries[];
          (.key | test("^[A-Za-z_][A-Za-z0-9_]*$")) and
          (.value | type == "string" and (contains("\u0000") | not)))
        then to_entries[] | "export \(.key)=\(.value | @sh)"
        else error("Invalid restic environment")
        end
      '
  '';

  shellInit = ''
    if restic_env="$(${resticEnv})"; then
      eval "$restic_env"
    else
      printf '%s\n' 'Could not load restic environment from SOPS.' >&2
    fi
    unset restic_env
  '';

  backupHome = pkgs.writeShellScript "restic-backup-home" ''
    set -eu

    restic_env="$(${resticEnv})"
    eval "$restic_env"
    unset restic_env

    if ! ${pkgs.restic}/bin/restic cat config >/dev/null 2>&1; then
      ${pkgs.restic}/bin/restic init
    fi

    ${pkgs.restic}/bin/restic backup ${lib.escapeShellArgs backupDirectories} \
      --one-file-system \
      --exclude-caches
  '';
in
{
  home.packages = [ pkgs.restic ];

  programs.bash.initExtra = lib.mkAfter shellInit;
  programs.zsh.initContent = lib.mkAfter shellInit;

  systemd.user.services.restic-backup-home = {
    Unit = {
      Description = "Back up selected directories to Cloud.ru Object Storage";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = backupHome;
    };
  };

  systemd.user.timers.restic-backup-home = {
    Unit.Description = "Daily backup of selected directories";
    Timer = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
