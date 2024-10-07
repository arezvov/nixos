{ config, pkgs, ... }:
{
    programs = {
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
    };
}
