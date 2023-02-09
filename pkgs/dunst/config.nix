{
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
        gap_size = 20;
        width = 500;
        height = 200;
        frame_width = 0;
        padding = 16;
        horizontal_padding = 16;
        corner_radius = 10;

        transparency = 10;
        font = "Sans 12";

        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 250;
        progress_bar_max_width = 450;

        show_indicators = false;
        alignment = "center";
        vertical_alignment = "center";
        word_wrap = true;
        markup = "full";
        format = "\"<b>%s</b>\\n<span font='8'>%b</span>\"";

        enable_recursive_icon_lookup = true;
        icon_position = "left";
        min_icon_size = 64;
        max_icon_size = 64;
    };
    urgency_low = {
        background = "\"#141929fe\"";
        foreground = "\"#dae1f2\"";
        highlight = "\"#6fa6e7\"";
        frame_color = "\"#272f57\"";
        timeout = 3;
    };
    urgency_normal = {
        background = "\"#141929fe\"";
        foreground = "\"#dae1f2\"";
        highlight = "\"#5ca1ff\"";
        frame_color = "\"#272f57\"";
        timeout = 5;
    };
    urgency_critical = {
        background = "\"#5ca1ffff\"";
        foreground = "\"#1c2138\"";
        highlight = "\"#fe6c5a\"";
        frame_color = "\"#52426e\"";
        timeout = 0;
    };
}
