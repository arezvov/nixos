{ config, pkgs, ... }:
with pkgs;
{
    services.blueman.enable = true;

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
