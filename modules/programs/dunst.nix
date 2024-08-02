{ lib, pkgs, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.generators)
        toINI;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        dunst
        theme;
in switchSystem system {
    linux.options.custom.dunst = {
        enable = mkOption {
            type = types.bool; default = false;
        };
    };
    linux.config = mkIf dunst.enable {
        environment.systemPackages = [ pkgs.dunst ];
        custom.user.configFile."dunst/dunstrc".text = toINI {} {
        };
    };
}
