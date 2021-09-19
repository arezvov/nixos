{ config, pkgs, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      . ${pkgs.nixUnstable}/share/bash-completion/completions/nix
    '';
    shellAliases = {
      rr = "sudo nixos-rebuild switch --flake /home/alex/nixos#laptop -L";
    };
  };
}
