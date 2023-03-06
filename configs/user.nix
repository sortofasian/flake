{ lib, system, config, ... }: let
    inherit (builtins)
        elem;
    inherit (lib)
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user;
in {
    options.custom.user = {
        name = mkOption { type = types.str; };
        passwordHash = mkOption { type = types.str; default = ""; };
    };

    config = let
        name = if elem user.name [ "" "root" ]
            then "charlie"
            else user.name;
    in ({
        nix.settings = let users = [ "root" name ]; in {
            trusted-users = users;
            allowed-users = users;
        };
    } // (switchSystem system  {
        linux = {
            users.users.${name} = {
                uid = 1000;
                inherit name;
                group = "users";
                isNormalUser = true;
                home = "/home/${name}";
                extraGroups = [ "wheel" ];
                description = "Primary user";
                hashedPassword = user.passwordHash;
            };
        };
        darwin = {
            
        };
    }));
}
