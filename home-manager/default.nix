{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./polybar.nix
  ];

  programs = {
    git = {
      enable = true;
      userEmail = "alex@rezvov.ru";
      userName = "Alexander Rezvov";
    };
    
    neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };
  };
  services = {
    mpris-proxy = {
      enable = true;
    };
  };
}
