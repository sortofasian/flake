{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user
        udisks;
in switchSystem system { linux = {
    options.custom.udisks.enable = mkOption {
        type = types.bool;
        default = false;
    };

    config = mkIf udisks.enable {
        services.udisks2.enable = true;
        #users.users.${user.name}.packages = mkIf desktop.enable [ pkgs.udiskie ];
    };
}; }
