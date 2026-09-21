{ config, pkgs, pkgs-master, ... }:
with pkgs;
{
    services.clipmenu.enable = false;
    services.espanso.enable = false;
    services.openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };

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
