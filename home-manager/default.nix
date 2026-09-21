{ pkgs, ... }:

{
  imports = [
    ./environment.nix
    ./secrets.nix
    ./shell.nix
    ./polybar.nix
    ./xsession.nix
    ./alacritty.nix
    ./dunst.nix
    ./gnupg.nix
    ./services.nix
    ./git.nix
    ./neovim.nix
    ./pyenv.nix
    ./restic.nix
    ./vscode.nix
  ];

  home.stateVersion = "24.11";

  xdg.desktopEntries.chatzone = {
    name = "Chatzone";
    genericName = "Ozon corporate messenger";
    exec = "${pkgs.chatzone-desktop}/bin/chatzone-desktop %u";
    icon = "chatzone-desktop";
    terminal = false;
    categories = [ "Network" "InstantMessaging" "Chat" ];
    mimeType = [ "x-scheme-handler/chatzone" "x-scheme-handler/mattermost" ];
    settings.StartupWMClass = "Chatzone";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "google-chrome.desktop" ];
      "x-scheme-handler/http" = [ "google-chrome.desktop" ];
      "x-scheme-handler/https" = [ "google-chrome.desktop" ];
      "x-scheme-handler/about" = [ "google-chrome.desktop" ];
      "x-scheme-handler/unknown" = [ "google-chrome.desktop" ];
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/chatzone" = [ "chatzone.desktop" ];
    };
    associations.added = {
      "x-scheme-handler/tg" = [ "org.telegram.desktop.desktop" ];
      "x-scheme-handler/tonsite" = [ "org.telegram.desktop.desktop" ];
    };
  };
}
