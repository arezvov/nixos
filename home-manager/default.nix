{ pkgs, ... }:

{
  imports = [
    ./bash.nix
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

    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        editorconfig-nvim
        YouCompleteMe
        vim-commentary
        vim-better-whitespace
        fugitive
        surround
        syntastic
        nerdtree
      ];
      extraConfig = ''
        au BufNewFile,BufRead Jenkinsfile setf groovy
        au BufNewFile,BufRead Jenkinsfile set shiftwidth=4

        autocmd FileType terraform setlocal commentstring=#\ %s
        autocmd FileType terraform let b:commentary_startofline=1


        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 1
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
