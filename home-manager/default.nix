{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./polybar.nix
    ./xsession.nix
    ./alacritty.nix
    ./dunst.nix
    ./gnupg.nix
  ];

  programs = {
    git = {
      enable = true;
      userEmail = "alex@rezvov.ru";
      userName = "Alexander Rezvov";
      extraConfig = {
        init = {
          defaultBranch = "master";
        };
      };
    };

    alacritty = {
      enable = true;
    };

    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        editorconfig-nvim
        YouCompleteMe
        vim-commentary
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
    clipmenu = {
      enable = true;
    };
  };
}
