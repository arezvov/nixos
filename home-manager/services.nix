{
  config,
  pkgs,
  pkgs-master,
  ...
}:

{
  services = {
    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
      # Keep devices and folders configured through the web interface.
      overrideDevices = false;
      overrideFolders = false;
    };
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
