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

  home.stateVersion = "23.05";
}
