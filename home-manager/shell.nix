{ config, pkgs, ... }:
let
  shellAliases = {
    rr = "sudo nixos-rebuild switch --flake /home/alex/nixos#$(hostname) -L";
  };
in {
  programs = {
    bash = {
      enable = true;
      inherit shellAliases;
      historySize = 500000;
      historyIgnore = [ "cd" "ls" ];
    };

    zsh = {
      enable = true;
      inherit shellAliases;
      history = {
        save = 500000;
        size = 500000;
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "af-magic";
      };
    };
  };
}
