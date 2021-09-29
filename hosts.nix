{ config, lib, pkgs, ... }:

{
  networking.extraHosts = ''
    172.16.100.147 ipmi.intr
    172.16.100.240 nh-dc-1.intr
  '';
}
