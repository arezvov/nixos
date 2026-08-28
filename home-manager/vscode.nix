{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs; [
      vscode-extensions.vscodevim.vim
      vscode-extensions.hashicorp.hcl
      vscode-extensions.hashicorp.terraform
    ];
  };
}
