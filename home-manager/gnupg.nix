{ config, pkgs, ... }:

{
  programs.gpg = {
    enable = true;
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 8 * 60 * 60;
    maxCacheTtl = 24 * 60 * 60;
    pinentry.package = pkgs.pinentry-qt;
    #pinentryFlavor = "qt";
  };
}
