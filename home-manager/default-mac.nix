{ pkgs, ... }:

{
  imports = [
    ./bash.nix
    #./alacritty.nix
    ./pyenv.nix
    ./vscode.nix
    ./neovim.nix
    ./common-packages.nix
  ];
  
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home.stateVersion = "23.05";
}
