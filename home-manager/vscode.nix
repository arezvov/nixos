{ config, pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        extensions = with pkgs; [
            vscode-extensions.vscodevim.vim
            vscode-extensions.hashicorp.hcl
            vscode-extensions.hashicorp.terraform  
        ];
    };
}