{ pkgs, lib, config, system, ... }: let
    inherit (builtins)
        elem;
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user
        desktop;

    x11WindowManagers = [
        "i3"
    ];
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
    };

    config = mkIf desktop.enable (mkMerge [
        (mkIf (desktop.wm == "i3") {
            users.users.${user.name}.packages = [ pkgs.autotiling ];
            services.xserver.windowManager.i3.enable = true;
        })

        (mkIf (elem desktop.wm x11WindowManagers) {
            users.users.${user.name}.packages = [ pkgs.xdotool ];
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
            services.picom = {
                enable = true;
                settings = {
                    backend = "glx";
                    vsync = false;
                    use-damage = true;
                    # window types: dock popup_menu dropdown_menu tooltip menu notification toolbar desktop
                    blur-background-exclude = [
                        "window_type = 'dock'"
                        "window_type = 'toolbar'"
                        "window_type = 'desktop'"

                        "name = 'rofi - drun'"
                    ];
                    rounded-corners-exclude = [
                        "window_type = 'dock'"
                        "window_type = 'toolbar'"
                        "window_type = 'desktop'"
                    ];
                    shadow-exclude = [
                        "window_type = 'dock'"
                        "window_type = 'notification'"
                        "window_type = 'toolbar'"
                        "window_type = 'desktop'"

                        "name = 'rofi - drun'"
                    ];
                    wintypes = [
                    ];
                };
            };
        })

        ({
            programs.dconf.enable = true;
            programs.gnupg.agent.pinentryFlavor = "qt";
            programs.seahorse.enable = true;
            users.users.${user.name}.packages = with pkgs; [
                feh
                playerctl
            ];
        })
    ]);
}; }
