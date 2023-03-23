{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        xdg
        desktop;
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
        {
            programs.dconf.enable = true;
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
        }

        (mkIf (desktop.wm == "i3") {
            services.xserver.windowManager.i3.enable = true;
        })

        (mkIf (desktop.compositor == "picom") {
            services.picom.enable = true;
        })

    ]);
}; }
