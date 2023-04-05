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
        shadowsocks = mkPort (basePort.default + 3);
        vaultwarden = mkPort (basePort.default + 4);
        velocity = mkPort (basePort.default + 5);

        lobby = mkPort (basePort.default + 100);
        atm8 = mkPort (basePort.default + 101);
    };
}
