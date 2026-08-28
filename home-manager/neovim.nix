{ config, pkgs, ... }:

{
  programs = {
    neovim = {
      enable = true;
      withPython3 = true;
      withRuby = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        editorconfig-nvim
        YouCompleteMe
        vim-commentary
        vim-better-whitespace
        vim-fugitive
        vim-surround
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

}
