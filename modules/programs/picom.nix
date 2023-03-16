{
    services.picom.settings = {
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
