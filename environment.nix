{ config, ... }:
let
  secrets = import ./secrets.nix;
in {
  environment.interactiveShellInit = '' 
    alias wtr='curl -H "Accept-Language: ru" wttr.in/Санкт-Петербург'
    alias rr='sudo nixos-rebuild switch -I nixos-config=/home/alex/nixos/configuration.nix'
    alias mj_clamav='/home/alex/work/scripts/python/clamav.py'
    export MJ_BILLING_LOGIN="${secrets.hms_login}"
    export MJ_BILLING_PASSWD="${secrets.hms_pass}"
    export CERBERUS_KEY='${secrets.cerb_key}'
    export CERBERUS_SECRET='${secrets.cerb_secret}'
    export SLACK_API_KEY='${secrets.slack_api_key}'
    export IPMI_PASSWORD='${secrets.ipmi_pass}'
    export SYSTEMD_PAGER=
    export NIXOS_CONFIG="/home/alex/nixos/configuration.nix"
    export LIBVIRT_DEFAULT_URI='qemu:///system'

    export HISTCONTROL=ignoreboth:erasedups
    export HISTSIZE=100000
    export HISTFILESIZE=100000
    export NIXPKGS_ALLOW_UNFREE=1
  '';

  programs = {
    nano.nanorc = ''
      set tabstospaces
      set tabsize 4
    '';
    bash.enableCompletion = true;
  };

  services = {
    clipmenu.enable = true;
    espanso.enable = true;

    openssh = {
      enable = true;
      forwardX11 = true;
    };
  };

  virtualisation = {
    libvirtd = {
      enable = true;
    };

    vswitch.enable = true;

    docker = {
      enable = true;
      enableOnBoot = true;
    };
  };


  time.timeZone = "Europe/Moscow";

  security.pki.certificates = [
    secrets.mj_certificate
  ];

  environment.etc = {
    "openvpn/mj.crt" = {
      text = secrets.mj_openvpn_cert;
    };

    "openvpn/auth" = {
      text = ''
        ${secrets.hms_login}
        ${secrets.hms_pass}
      '';
    };

    "openvpn/mj.conf" = {
      text = ''
        client
        port 1194
        proto udp
        dev tap
        remote ${secrets.mj_openvpn_host} 
        tls-version-min 1.0
        ca "/etc/openvpn/mj.crt"
        auth-user-pass /etc/openvpn/auth
        comp-lzo
        mssfix
        auth SHA1
        script-security 3
        daemon
        nobind
        verb 4
        status /var/log/openvpn/openvpn-status.log 1
        status-version 3
        log-append /var/log/openvpn/openvpn-client.log
      '';
    };
  };
}
