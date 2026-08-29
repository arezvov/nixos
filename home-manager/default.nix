{ ... }:

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
    ./restic.nix
    ./vscode.nix
  ];

  home.stateVersion = "24.11";
}
