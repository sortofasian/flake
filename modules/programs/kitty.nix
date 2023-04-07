{ pkgs, config, ... }: let
    inherit (config.custom.theme)
        colors;
in {
    environment.systemPackages = [ pkgs.kitty ];
    environment.variables.TERM = "kitty";
    environment.variables.TERMINAL = "kitty";
    custom.user.configFile."kitty/kitty.conf".text = ''
        font_family Fira Code Medium Nerd Font Complete
        font_size 13.0
        undercurl_style thick-sparse
        cursor none

        scrollback_lines 10000
        scrollback_pager_history_size 2000

        mouse_hide_wait 3.0

        macos_titlebar_color #${colors.bg}
        window_margin_width 5

        foreground #${colors.fg}
        background #${colors.bg}
        selection_foreground none
        selection_background none

        color0  #${colors.black}
        color1  #${colors.red}
        color2  #${colors.green}
        color3  #${colors.yellow}
        color4  #${colors.blue}
        color5  #${colors.magenta}
        color6  #${colors.cyan}
        color7  #${colors.white}

        color8  #${colors.brightblack}
        color9  #${colors.brightred}
        color10 #${colors.brightgreen}
        color11 #${colors.brightyellow}
        color12 #${colors.brightblue}
        color13 #${colors.brightmagenta}
        color14 #${colors.brightcyan}
        color15 #${colors.brightwhite}

        background_opacity 0.85
    '';
}
