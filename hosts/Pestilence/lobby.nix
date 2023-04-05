{ config, ... }: let
    inherit (config.custom)
        ports;
in {
    services.minecraft-server = {
        enable = true;
        eula = true;
        dataDir = /srv/lobby;
        declarative = true;
        serverProperties = {
            server-port = ports.lobby;
            difficulty = 3;
            gamemode = 1;
        };
    };
}
