{ config, inputs, ... }:

let
  secrets = inputs.secrets.secrets;
in {
  environment.etc = {
    "openvpn/mj.crt" = {
      text = secrets.mj_openvpn_cert;
    };

    "openvpn/nh.crt" = {
      text = secrets.nh_openvpn_cert;
    };

    "openvpn/auth-nh" = {
      text = ''
        ${secrets.nh_login}
        ${secrets.nh_pass}
      '';
    };


    "openvpn/auth-mj" = {
      text = ''
        ${secrets.hms_login}
        ${secrets.hms_pass}
      '';
    };

    "openvpn/nh.conf" = {
      text = ''
        client
        remote ${secrets.nh_openvpn_host}
        comp-lzo yes
        mssfix 1200
        dev tap
        proto udp
        nobind
        auth-nocache
        auth SHA512
        cipher BF-CBC
        data-ciphers AES-256-GCM:AES-128-GCM:BF-CBC
        script-security 2
        persist-key
        persist-tun
        auth-user-pass /etc/openvpn/auth-nh
        ca "/etc/openvpn/nh.crt"
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
        auth-user-pass /etc/openvpn/auth-mj
        comp-lzo
        mssfix
        auth SHA1
        data-ciphers BF-CBC:AES-256-GCM:AES-128-GCM
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
