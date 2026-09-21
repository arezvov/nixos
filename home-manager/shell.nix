{ ... }:
let
  shellAliases = {
    wtr = "curl -H \"Accept-Language: ru\" wttr.in/Санкт-Петербург";
    mj_clamav = "/home/alex/work/scripts/python/clamav.py";
    rr = "sudo nixos-rebuild switch --flake /home/alex/nixos#$(hostname) -L";
  };
  shellInit = ''
    string_heap() {
      pid=$1
      range=`grep heap /proc/''${pid}/maps | cut -d' ' -f1`
      dd status=none if=/proc/''${pid}/mem ibs=4096 skip=$((16#''${range/-*/}/4096)) count=$(((16#''${range/*-/}-16#''${range/-*/})/4096)) | strings
    }
    string_stack() {
      pid=$1
      range=`grep stack /proc/''${pid}/maps | cut -d' ' -f1`
      dd status=none if=/proc/''${pid}/mem ibs=4096 skip=$((16#''${range/-*/}/4096)) count=$(((16#''${range/*-/}-16#''${range/-*/})/4096)) | strings
    }
  '';
in
{
  programs = {
    bash = {
      enable = true;
      inherit shellAliases;
      enableCompletion = true;
      initExtra = shellInit;
      historyControl = [
        "ignoreboth"
        "erasedups"
      ];
      historySize = 500000;
      historyIgnore = [
        "cd"
        "ls"
      ];
    };

    zsh = {
      enable = true;
      inherit shellAliases;
      initContent = shellInit;
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
