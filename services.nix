{ config, pkgs, pkgs-master, ... }:
with pkgs;
{
    services.blueman.enable = true;

    services.netbird = {
      enable = true;
      package = pkgs-master.netbird;
      ui = {
        enable = true;
        package = pkgs-master.netbird-ui;
      };
    };

    services.sysstat = {
      enable = true;
    };

    services.postgresql = {
      enable = false;
      identMap = ''
        alex-psql alex postgres
      '';
    };
}
