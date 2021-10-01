{ config, lib, pkgs, ... }:

{
  networking.extraHosts = ''
    172.16.100.147 ipmi1.intr
    172.16.100.164 ipmi2.intr
    172.16.100.192 ipmi3.intr

    172.16.100.240 nh-dc-1.intr
    172.16.100.241 nh-dc-2.intr
    172.16.100.242 nh-dc-3.intr
  '';
}
