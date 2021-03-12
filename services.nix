{ config, pkgs, ... }:
with pkgs;
{
    systemd.user.services = {
        polybar = {
            script = "${polybarFull}/bin/polybar example";
            serviceConfig = {
                Restart = "always";
            }; 
        };

        mpris-proxy = {
            script = "${bluez}/bin/mpris-proxy";
            serviceConfig = {
                Restart = "always";
            };
            after = [ "bluetooth.target" ];
        };
    };
}
