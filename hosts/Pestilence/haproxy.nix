{ config, ... }: let
    inherit (config.custom)
        ports;
in {
    services.haproxy.enable = true;
    services.haproxy.config = ''
        global
            ssl-default-bind-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
            ssl-default-bind-options prefer-client-ciphers no-sslv3 no-tlsv10 no-tlsv11 no-tlsv12 no-tls-tickets

            ssl-default-server-ciphersuites TLS_AES_128_GCM_SHA256:TLS_AES_256_GCM_SHA384:TLS_CHACHA20_POLY1305_SHA256
            ssl-default-server-options no-sslv3 no-tlsv10 no-tlsv11 no-tlsv12 no-tls-tickets

            ca-base /srv/.lego/certificates
            crt-base /srv/.lego/certificates

        frontend http
            mode http
            bind :80
            bind :443 ssl crt sortofasian.io.pem alpn h2,http/1.1
            redirect scheme https if !{ ssl_fc }

            use_backend vaultwarden if { hdr_beg(host) -i vw }
            default_backend nginx

        frontend ssh
            mode tcp
            bind :22
            default_backend ssh

        frontend minecraft
            mode tcp
            bind :25565
            default_backend velocity

        frontend shadowsocks
            mode tcp
            bind :994
            default_backend shadowsocks

        backend nginx
            mode http
            server main 127.0.0.1:${builtins.toString ports.nginx} check
        backend vaultwarden
            mode http
            server main 127.0.0.1:${builtins.toString ports.vaultwarden} check
        backend ssh
            mode tcp
            server main 127.0.0.1:${builtins.toString ports.sshd}

        backend shadowsocks
            mode tcp
            server main 127.0.0.1:${builtins.toString ports.shadowsocks} check
        backend velocity
            mode tcp
            server main 127.0.0.1:${builtins.toString ports.velocity} check send-proxy
    '';
    networking.firewall.allowedTCPPorts = [
        22
        80
        443
        994
    ];
    networking.firewall.allowedUDPPorts = [
        994
        25565
    ];
}
