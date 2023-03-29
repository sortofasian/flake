{ lib, name, config, ... }: let
    inherit (lib)
        mkIf
        mkMerge;
    inherit (lib.custom)
        switch;
    inherit (config.custom)
        age
        user;
in mkIf age.enable {
    age.secrets = mkMerge [
        {
            login = {
                file = ./secrets/login.age;
            };
            pam-yubikeys = {
                file = ./secrets/pam-yubikeys.age;
                owner = user.name;
            };
            ssh-yubikey-5 = {
                file = ./secrets/ssh-yubikey-5.age;
                owner = user.name;
            };
            ssh-yubikey-5c = {
                file = ./secrets/ssh-yubikey-5c.age;
                owner = user.name;
            };
        }
        (mkIf (name == "Pestilence") {
            vpn-privkey = {
                file = ./secrets/vpn-privkey.age;
            };
            vpn-password = {
                file = ./secrets/vpn-password.age;
            };
        })
    ];

    custom.age.systemIdentity.file = switch name (c: v: c==v) {
        "War"        = ./secrets/key-war.age;
        "Death"      = ./secrets/key-death.age;
        "Famine"     = ./secrets/key-famine.age;
        "Pestilence" = ./secrets/key-pestilence.age;
    };
}
