{ lib, system, ... }: let
    inherit (lib.custom)
        switchSystem;
in switchSystem system {
    linux.services.picom.settings = {
        shadow = true;
        shadow-opacity = 0.30;
        shadow-radius = 20;
        shadow-offset-x = -20;
        shadow-offset-y = -20;
        corner-radius = 10;
        blur = {
            size = 40;
        };

        backend = "glx";
        vsync = false;
        use-damage = true;
        blur = {
            method = "dual-kawase";
            deviation = 5.0;
        };
        blur-background = true;
        blur-background-frame = true;
        # window types: dock popup_menu dropdown_menu tooltip menu notification toolbar desktop
        blur-background-exclude = [
            "window_type = 'dock'"
            "window_type = 'toolbar'"
            "window_type = 'desktop'"

            "name = 'rofi - drun'"
        ];
        shadow-exclude = [
            "window_type = 'dock'"
            "window_type = 'notification'"
            "window_type = 'toolbar'"
            "window_type = 'desktop'"

            "name = 'rofi - drun'"
        ];
        rounded-corners-exclude = [
            "window_type = 'dock'"
            "window_type = 'toolbar'"
            "window_type = 'desktop'"
        ];
        wintypes = [
        ];
    };
}
