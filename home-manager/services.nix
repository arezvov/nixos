{ config, pkgs, pkgs-master, ... }:

{
  services = {
    mpris-proxy = {
      enable = true;
    };
    clipmenu.enable = false;
    clipcat = {
      enable = true;
      package = pkgs-master.clipcat;
      enableZshIntegration = false;
      daemonSettings = builtins.fromTOML (builtins.readFile ./clipcatd.toml);
      menuSettings.finder = "rofi";
    };
    flameshot = {
      enable = true;
      settings.General = {
        useX11LegacyScreenshot = true;
        captureActiveMonitor = true;
      };
    };
  };
}
