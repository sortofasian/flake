{ lib, system, config, ... }: let
    inherit (lib)
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        age
        user;
    inherit (config.age)
        secrets;
in {
    options.custom.user = {
        # TODO: need to add assertions
        name = mkOption {
            type = types.str;
            default = "";
        };
        home = mkOption {
            type = types.path;
            default = "/home/${user.name}";
        };
        uid = mkOption {
            type = types.int;
            default = 1000;
        };
        passwordFile = mkOption {
            type = types.nullOr types.path;
            default = if age.enable
                then secrets.login.path
                else null;
        };
    };

    config = switchSystem system {
        linux.users = {
            mutableUsers = !age.enable;
            groups = {
                "plugdev" = {};
            };
            users.${user.name} = {
                uid = 1000;
                inherit (user) name home;
                group = "users";
                isNormalUser = true;
                extraGroups = [ "wheel" "dialout" "plugdev" ];
                passwordFile = user.passwordFile;
            };
        };
    };
}
