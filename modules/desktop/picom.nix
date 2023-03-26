{ lib, system, config, ... }: let
    inherit (lib)
        mkIf;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        gpu
        theme
        desktop;
in mkIf (desktop.compositor == "picom") (switchSystem system {
    linux.services.picom.enable = true;
    linux.services.picom.settings = {
        backend    = mkIf (gpu != null) "glx";
        vsync      = false;
        use-damage = true;

        shadow          = theme.shadows.enable;
        shadow-opacity  = theme.shadows.opacity;
        shadow-radius   = theme.shadows.radius;
        shadow-offset-x = theme.shadows.offsetX;
        shadow-offset-y = theme.shadows.offsetY;
        shadow-exclude  = [
            "window_type = 'dock'"
            "window_type = 'toolbar'"
        ];

        blur-background       = false;#theme.blur.enable;
        blur-radius           = mkIf theme.blur.enable theme.blur.radius;
        #blur-strength = 10;
        blur-background-frame = true;
        blur-method           = "dual_kawase";
        blur-background-exclude = [
            "class_g ?= 'xborders'"
            "class_g ?= 'xborder'"
        ];

        corner-radius = theme.cornerRadius;
        rounded-corners-exclude = [
            "window_type = 'dock'"
            "window_type = 'toolbar'"
        ];
    };
})
