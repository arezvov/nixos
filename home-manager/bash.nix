{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ${pkgs.nixUnstable}/share/bash-completion/completions/nix

      function wi() {
        readlink -f $(type -p $1)
      }
    '';
    shellAliases = {
      rr = "sudo nixos-rebuild switch --flake /home/alex/nixos#$(hostname) -L";
    };
    historySize = 500000;
    historyIgnore = [ "cd" "ls" ];

  };
}
