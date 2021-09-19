{ config, inputs, ... }: 

let
  secrets = inputs.secrets.secrets;
in {
  environment.etc = {
    "openvpn/mj.crt" = {
      text = secrets.mj_openvpn_cert;
    };

    "openvpn/auth-mj" = {
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
        auth-user-pass /etc/openvpn/auth-mj
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
