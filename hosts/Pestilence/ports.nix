{ lib, ... }: let
    inherit (lib)
        types
        mkOption;
    mkPort = port: mkOption {
        type = types.port;
        default = port;
    };
in {
    options.custom.ports = rec {
        basePort = mkPort 42000;
        sshd = mkPort (basePort.default + 1);
        nginx = mkPort (basePort.default + 2);
        vaultwarden = mkPort (basePort.default + 4);

        velocity = mkPort 25565;
        shadowsocks = mkPort 994;

        lobby = mkPort (basePort.default + 100);
        atm8 = mkPort (basePort.default + 101);
        bbb = mkPort (basePort.default + 102);
    };
    config.networking.firewall.allowedTCPPorts = [
        994
        25565
    ];
    config.networking.firewall.allowedUDPPorts = [
        994
        25565
    ];
}
