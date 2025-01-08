{ config, inputs, ... }:
let
  secrets = inputs.secrets.secrets;
in {
  environment.interactiveShellInit = '' 
    alias wtr='curl -H "Accept-Language: ru" wttr.in/Санкт-Петербург'
    alias rr='sudo nixos-rebuild switch -I nixos-config=/home/alex/nixos/configuration-${config.networking.hostName}.nix'
    alias mj_clamav='/home/alex/work/scripts/python/clamav.py'
    export MJ_BILLING_LOGIN="${secrets.hms_login}"
    export MJ_BILLING_PASSWD="${secrets.hms_pass}"
    export RPC_USER="${secrets.hms_login}"
    export RPC_PASSWORD="${secrets.hms_pass}"
    export CERBERUS_KEY='${secrets.cerb_key}'
    export CERBERUS_SECRET='${secrets.cerb_secret}'
    export SLACK_API_KEY='${secrets.slack_api_key}'
    export IPMI_PASSWORD='${secrets.ipmi_pass}'
    export SYSTEMD_PAGER=
    export NIXOS_CONFIG="/home/alex/nixos/configuration.nix"
    export LIBVIRT_DEFAULT_URI='qemu:///system'

    export GALERA_ROOT_PASSWORD='${secrets.galera_root_pass}'

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
    clipmenu.enable = true;
    espanso.enable = true;
    clipcat.enable = true;

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

  security.pki.certificates = [
    secrets.mj_certificate
  ];

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
