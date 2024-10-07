{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./alacritty.nix
  ];

  home.stateVersion = "23.05";

  programs = {
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

        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 1
      '';
    };
  };
}
