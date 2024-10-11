{ config, pkgs, ... }:

{
    programs.pyenv = {
        enable = true;
        enableBashIntegration = true;
    };
}