{ config, pkgs, ... }:
{
  programs = {
    bash = {
      enable = true;
      shellAliases = {
        rr = "sudo nixos-rebuild switch --flake /home/alex/nixos#$(hostname) -L";
      };
      historySize = 500000;
      historyIgnore = [ "cd" "ls" ];
    };

    zsh = {
      enable = true;
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
