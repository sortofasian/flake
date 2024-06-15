{config, pkgs, lib, ...}: {
    services = {
        bazarr = {
            enable = true;
            group  = "arr";
        };
        sonarr = {
            enable  = true;
            group   = "arr";
            dataDir = "/mutable/sonarr";
        };
        radarr = {
            enable  = true;
            group   = "arr";
            dataDir = "/mutable/radarr";
        };

        jellyfin = {
            enable = true;
            group  = "arr";
        };

        prowlarr.enable   = true;
        jellyseerr.enable = true;

        transmission = {
            enable = true;
            group = "arr";
            home = "/mutable/transmission";
            settings = {
                watch-dir-enabled = false;
                download-dir = "/mutable/transmission/Downloads";
                rpc-host-whitelist-enabled = false;
                rpc-username = "charlie";
                rpc-password = "{c1eaa9c995b14991dcf6df0c8333916629b5537aZRFppgWg";

                encryption = 2;
                download-queue-enabled = true;
            };
        };
    };

    systemd.services.jellyfin.serviceConfig = {
        DeviceAllow = pkgs.lib.mkForce [ "char-drm rw" "char-nvidia-frontend rw" "char-nvidia-uvm rw" ];
        PrivateDevices = pkgs.lib.mkForce true;
        RestrictAddressFamilies = pkgs.lib.mkForce [ "AF_UNIX" "AF_NETLINK" "AF_INET" "AF_INET6" ];
    };

    systemd.services.flood = {
        description = "flood";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = rec {
            Type = "simple";
            User = "flood";
            Group = "arr";
            StateDirectory = "flood";
            SyslogIdentifier = "flood";
            ExecStart = pkgs.writeShellScript "start-flood" ''
                ${pkgs.flood}/bin/flood \
                --port ${toString config.custom.ports.flood} \
                --rundir /mutable/flood
            '';
            Restart = "on-failure";
        };
    };

    users = {
        users = {
            transmission.createHome = true;
            flood = {
                createHome = true;
                isSystemUser = true;
                group = "arr";
                home = "/mutable/flood";
            };
        };
        groups.arr = {};
    };

    environment.systemPackages = with pkgs; [wallabag paperless-ngx];
}
