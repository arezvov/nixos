{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./polybar.nix
    ./xsession.nix
    ./alacritty.nix
  ];

  programs = {
    git = {
      enable = true;
      userEmail = "alex@rezvov.ru";
      userName = "Alexander Rezvov";
    };

    alacritty = {
      enable = true;
    };

    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        YouCompleteMe
      ];
      extraConfig = ''
        au BufNewFile,BufRead Jenkinsfile setf groovy
        au BufNewFile,BufRead Jenkinsfile set shiftwidth=4
      '';
    };
  };
  services = {
    mpris-proxy = {
      enable = true;
    };
  };
}
