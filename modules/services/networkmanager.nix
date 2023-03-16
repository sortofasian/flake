{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user
        desktop
        networkmanager;
in switchSystem system { linux = {
    options.custom.networkmanager.enable = mkOption {
        type = types.bool;
        default = true;
    };

    config = mkIf networkmanager.enable {
        networking.networkmanager.enable = true;
        users.users.${user.name}.packages = mkIf desktop.enable (with pkgs; [
            networkmanagerapplet
        ]);
    };
}; }
