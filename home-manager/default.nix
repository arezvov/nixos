{ pkgs, ... }:

{
  imports = [
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
    ./vscode.nix
  ];

  home.stateVersion = "24.11";

  programs = {
    vscode = {
      enable = true;
    };

    git = {
      enable = true;
      userEmail = "alex@rezvov.ru";
      userName = "Alexander Rezvov";
      signing = {
        key = "A12A7532A32DF8DCFD391AC87E9400C4F7763DE6";
        signByDefault = true;
      };
      extraConfig = {
        init = {
          defaultBranch = "master";
        };
      };
    };

    alacritty = {
      enable = true;
    };

  };
  
  services = {
    mpris-proxy = {
      enable = true;
    };
    clipmenu = {
      enable = true;
    };
  };
}
