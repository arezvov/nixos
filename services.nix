{ config, pkgs, ... }:
with pkgs;
{
    services.sysstat = {
      enable = true;
    };

    services.postgresql = {
      enable = false;
      identMap = ''
        alex-psql alex postgres
      '';
    };
    services.openssh = {
      enable = true;
      forwardX11 = true;
    };
}
