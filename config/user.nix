{ lib, system, config, ... }: let
    inherit (builtins)
        elem;
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user;
    inherit (config.age)
        secrets;
in {
    options.custom.user = {
        # TODO: need to require username
        name = mkOption {
            type = types.nullOr types.str;
            default = null;
        };
        passwordFile = mkOption {
            type = types.str;
            default = secrets.login.path;
       };
    };

    config = let
        name = if elem user.name [ "" "root" ]
            then null else user.name;
    in (mkIf (name != null) ({
        nix.settings = let users = [ "root" name ]; in {
            trusted-users = users;
            allowed-users = users;
        };
    } // (switchSystem system  { linux = {
            users.mutableUsers = false;
            users.users.${name} = {
                uid = 1000;
                inherit name;
                group = "users";
                isNormalUser = true;
                home = "/home/${name}";
                extraGroups = [ "wheel" ];
                passwordFile = user.passwordFile;
            };
        }; })
    ));
}
