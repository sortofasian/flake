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
        name = mkOption { type = types.nullOr types.str; default = null; };
        passwordFile = mkOption { type = types.str; default = secrets.login.path; };
    };

    config = let
        name = if elem user.name [ "" "root" ]
            then null else user.name;
    in ({
        nix.settings = let users = [ "root" name ]; in {
            trusted-users = users;
            allowed-users = users;
        };
    } // (mkIf (name != null) (switchSystem system  {
        linux = {
            users.users.${name} = {
                uid = 1000;
                inherit name;
                group = "users";
                isNormalUser = true;
                home = "/home/${name}";
                extraGroups = [ "wheel" ];
                description = "Primary user";
                passwordFile = user.passwordFile;
            };
        };
        darwin = {
            
        };
    }))
    );
}
