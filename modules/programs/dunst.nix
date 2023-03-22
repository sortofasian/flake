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
            global = {
                follow = "keyboard";
                notification_limit = 3;
                idle_threshold = 0;
                show_age_threshold = 15;
                sticky_history = true;
                history_length = 200;
                fullscreen = "pushback";

                origin = "bottom-center";
                offset = "0x85";
                gap_size = theme.gapSize;
                padding = theme.gapSize;
                horizontal_padding = theme.gapSize;
                width = 500;
                height = 200;
                frame_width = 0;
                corner_radius = theme.cornerRadius;

                transparency = 100 - theme.opacity * 100;
                font = "Sans 12";

                show_indicators = false;
                alignment = "center";
                vertical_alignment = "center";
                word_wrap = true;
                markup = "full";
                format = ''"<b>%s</b>\\n<span font='8'>%b</span>"'';

                enable_recursive_icon_lookup = true;
                icon_position = "left";
                min_icon_size = 64;
                max_icon_size = 64;
            };
            urgency_low = {
                background  = ''"#${theme.colors.black}"'';
                foreground  = ''"#${theme.colors.white}"'';
                highlight   = ''"#${theme.colors.blue}"'';
                frame_color = ''"#${theme.colors.brightblack}"'';
                timeout = 3;
            };
            urgency_normal = {
                background  = ''"#${theme.colors.black}"'';
                foreground  = ''"#${theme.colors.white}"'';
                highlight   = ''"#${theme.colors.blue}"'';
                frame_color = ''"#${theme.colors.brightblack}"'';
                timeout = 5;
            };
            urgency_critical = {
                background  = ''"#${theme.colors.blue}ff"'';
                foreground  = ''"#${theme.colors.black}"'';
                highlight   = ''"#${theme.colors.red}"'';
                frame_color = ''"#${theme.colors.magenta}"'';
                timeout = 0;
            };
        };
    };
}
