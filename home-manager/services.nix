{ config, pkgs, ... }:

{
  services = {
    mpris-proxy = {
      enable = true;
    };
    clipmenu = {
      enable = true;
    };
    flameshot.enable = true;
  };
}