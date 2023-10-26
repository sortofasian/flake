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
            type = types.nullOr (types.enum [ "i3" "hyprland" ]);
            default = null;
        };
        compositor = mkOption {
            type = types.nullOr (types.enum [ "picom" ]);
            default = "picom";
        };
    };

    config = mkIf desktop.enable (mkMerge [
        {
            programs.dconf.enable = true;
            services.xserver = {
                enable = true;
                updateDbusEnvironment = true;
                excludePackages = [ pkgs.dmenu ];

                layout = "us";
                autoRepeatDelay = 250;
                autoRepeatInterval = 20;
                libinput.enable = true;
                libinput.mouse = {
                    accelProfile = "flat";
                    accelSpeed = "0";
                };
                displayManager.gdm = {
                    enable = true;
                    wayland = true;
                };
            };
            environment.sessionVariables = {
                XCOMPOSECACHE = "${xdg.cache}/X11/xcompose";
                XCOMPOSEFILE  = "${xdg.runtime}/X11/xcompose";
                ERRFILE       = "${xdg.state}/X11/xsession-errors";
                WLR_NO_HARDWARE_CURSORS = "1";
            };

            xdg.sounds.enable = true;
            xdg.portal.enable = true;

            security.polkit.enable = true;
            systemd = {
                user.services.polkit-gnome-authentication-agent-1 = {
                    description = "polkit-gnome-authentication-agent-1";
                    wantedBy = [ "graphical-session.target" ];
                    wants = [ "graphical-session.target" ];
                    after = [ "graphical-session.target" ];
                    serviceConfig = {
                        Type = "simple";
                        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                        Restart = "on-failure";
                        RestartSec = 1;
                        TimeoutStopSec = 10;
                    };
                };
            };
        }
    ]);
}; }
