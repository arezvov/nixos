{ config, lib, pkgs, ... }:

{
  networking.extraHosts = ''
    78.108.80.33 web15majordomoru.aq
    130.61.186.90 ask-joiner.ru vpn.rezvov.ru
  '';
}
