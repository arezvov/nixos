{ config, pkgs, ... }:
with pkgs;
{
    services.sysstat = {
      enable = true;
    };

    services.postgresql = {
      enable = true;
      identMap = ''
        alex-psql alex postgres
      '';
    };
}
