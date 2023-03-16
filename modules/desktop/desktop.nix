{ pkgs, lib, config, system, ... }: let
    inherit (builtins)
        elem;
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        mkSwitch
        switchSystem;
    inherit (config.custom)
        xdg
        user
        desktop;
    xConfig = {
        services.xserver = {
            enable = true;
            updateDbusEnvironment = true;
            excludePackages = [ pkgs.dmenu ];

            layout = "us";
            xkbVariant = ""; # ?
            autoRepeatDelay = 250;
            autoRepeatInterval = 20;
            libinput.enable = true;
            libinput.mouse = {
                accelProfile = "flat";
                accelSpeed = "0";
            };
        };
        environment.variables = {
            XCOMPOSECACHE = "${xdg.cache}/X11/xcompose";
            XCOMPOSEFILE  = "${xdg.runtime}/X11/xcompose";
            ERRFILE       = "${xdg.state}/X11/xsession-errors";
        };
    };
in switchSystem system { linux = {
    options.custom.desktop = {
        enable = mkOption {
            type = types.bool;
            default = false;
        };
        wm = mkOption {
            type = types.nullOr (types.enum [ "i3" ]);
            default = null;
        };
        compositor = mkOption {
            type = types.nullOr (types.enum [ "picom" ]);
            default = "picom";
        };
        # TODO: add assertion requiring wm & desktop.enable
    };

    config = mkIf desktop.enable (mkMerge [
        { programs.dconf.enable = true; }

        (let
            xWM = config: xConfig // config;
        in mkSwitch desktop.wm (v: c: v == c) {
            i3 = xWM { services.xserver.windowManager.i3.enable = true; };
        })

        (mkSwitch desktop.compositor (v: c: v == c) {
            picom = { services.picom.enable = true; };
        })

    ]);
}; }
