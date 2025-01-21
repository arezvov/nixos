{ config, inputs, pkgs-master, ... }:

{
  environment.interactiveShellInit = '' 
    alias wtr='curl -H "Accept-Language: ru" wttr.in/Санкт-Петербург'
    alias rr='sudo nixos-rebuild switch -I nixos-config=/home/alex/nixos/configuration-${config.networking.hostName}.nix'
    alias mj_clamav='/home/alex/work/scripts/python/clamav.py'
    export SYSTEMD_PAGER=
    export NIXOS_CONFIG="/home/alex/nixos/configuration.nix"
    export LIBVIRT_DEFAULT_URI='qemu:///system'

    export HISTCONTROL=ignoreboth:erasedups
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    export NIXPKGS_ALLOW_UNFREE=1

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

  programs = {
    nano.nanorc = ''
      set tabstospaces
      set tabsize 4
    '';
    bash.completion.enable = true;
    zsh.enable = true;
  };

  services = {
    clipmenu.enable = false;
    espanso.enable = true;
    clipcat = {
      enable = true;
      package = pkgs-master.clipcat;
    };
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };

    vswitch.enable = true;

    docker = {
      enable = true;
      liveRestore = false;
      enableOnBoot = true;
    };
  };


  time.timeZone = "Europe/Moscow";

  security.polkit = {
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.policykit.exec" || action.id == "org.freedesktop.systemd1.manage-units") &&
          subject.user == "alex") {
            return polkit.Result.YES;
        }
      });
    '';
  };
}
