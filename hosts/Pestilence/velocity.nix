{ lib, pkgs, config, ... }: let
    inherit (lib)
        types
        mkOption;
    inherit (config.custom.mc)
        forwardingSecret;

    velocityDir = "/srv/velocity";

    velocity = let
        version = "3.2.0-SNAPSHOT";
        build = "247";
    in pkgs.fetchurl {
        sha256 = "e75becc4bf9f9426d9daa6b801eb6cb46025c98bc11e4f99ad1ddedf9e3fd0f3";
        url = "https://api.papermc.io/v2/projects/velocity"
        + "/versions/${version}/builds/${build}/velocity-${version}-${build}.jar";
    };

    velocityConfig = pkgs.writeText "velocity.toml" ''
        config-version = "2.6"
        bind = "0.0.0.0:25565"
        motd = "<#ffb8f0>sortofasian.io"
        show-max-players = 0

        online-mode = true
        froce-key-authentication = true
        prevent-client-proxy-connections = false
        kick-existing-players = false

        player-info-forwarding-mode = "modern"
        forwarding-secret-file = "${pkgs.writeText "forwarding.secret" forwardingSecret}"
        announce-forge = true
        ping-passthrough = "disabled"

        [servers]
        lobby = "127.0.0.1:30000"
        atm8  = "127.0.0.1:30001"

        try = [ "lobby" ]

        [forced-hosts]
        "atm8.sortofasian.io" = [ "atm8" ]

        [advanced]
        compression-threshold = 256
        compression-level = 6
        login-ratelimit = 3000
        connection-timeout = 5000
        read-timeout = 30000
        haproxy-protocol = false
        tcp-fast-open = true
        bungee-plugin-message-channel = true
        show-ping-requests = true
        failover-on-unexpected-server-disconnect = true
        announce-proxy-commands = true
        log-command-executions = true
        log-player-connections = true

        [query]
        enabled = false
    '';
    ambassador = pkgs.fetchurl {
        url = "https://github.com/adde0109"
        + "/Ambassador/releases/download"
        + "/v1.3.0-beta/Ambassador-Velocity-1.3.0-beta-all.jar";
        sha256 = "sha256-atvcl6fVQa1Ormn4JThNEWBL9RRXv5z1wEcPPrlBtmQ=";
    };
in {
    config.networking.firewall.allowedTCPPorts = [ 25565 ];
    config.systemd = {
        sockets.velocity = {
            bindsTo = ["velocity.service"];
            socketConfig = {
                ListenFIFO = "${velocityDir}/velocity.stdin";
                RemoveOnStop = true;
                FlushPending = true;
            };
        };
        services.velocity = {
            description = "Velocity Minecraft Proxy";
            wantedBy    = [ "multi-user.target" ];
            requires    = [ "velocity.socket" ];
            after       = [ "network.target" "velocity.socket" ];

            preStart = ''
                mkdir -p ${velocityDir}/plugins
                ln -sf ${ambassador} ${velocityDir}/plugins/
                ln -sf ${velocityConfig} ${velocityDir}/velocity.toml
            '';

            script = ''
                ${pkgs.jre}/bin/java \
                    -Xms512M -Xmx512M \
                    -XX:+UseG1GC \
                    -XX:G1HeapRegionSize=4M \
                    -XX:+UnlockExperimentalVMOptions \
                    -XX:+ParallelRefProcEnabled \
                    -XX:+AlwaysPreTouch \
                    -XX:MaxInlineLevel=15 \
                    -jar ${velocity}
            '';

            serviceConfig = {
                Restart   = "always";
                WorkingDirectory = "${velocityDir}";

                StandardInput = "socket";
                StandardOutput = "journal";
                StandardError = "journal";
            };
        };
    };

    options.custom.mc.forwardingSecret = mkOption {
        type = types.str;
        default = "FDujQE5rlLki";
    };
}
