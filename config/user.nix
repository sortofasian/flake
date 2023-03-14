{ lib, system, config, ... }: let
    inherit (lib)
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
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
            type = types.path;
            default = secrets.login.path;
        };
    };

    config = mkMerge [
        (switchSystem system  { linux = {
            users.mutableUsers = false;
            users.users.${user.name} = {
                uid = 1000;
                inherit (user) name home;
                group = "users";
                isNormalUser = true;
                extraGroups = [ "wheel" ];
                passwordFile = user.passwordFile;
            };
        }; })
        {
            nix.settings = let users = [ "root" user.name ]; in {
                trusted-users = users;
                allowed-users = users;
            };
        }
    ];
}
