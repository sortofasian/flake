{ pkgs, lib, config, system, ... }: let
    inherit (builtins)
        toString;
    inherit (lib)
        mkIf
        makeBinPath
        concatMapStringsSep;
    inherit (lib.custom)
        switchSystem;
    inherit (pkgs)
        writeShellScript;
    inherit (config.custom)
        theme
        desktop;

    killScript = writeShellScript "closewindow" ''
        export PATH=${makeBinPath (with pkgs; [xdotool xorg.xprop])}:$PATH

        id=$(xdotool getactivewindow)
        class=$(xprop -id $id WM_CLASS)
        if [[ $class = *"Steam"* ]];
            then xdotool windowunmap $id;
            else i3-msg kill;
        fi
    '';
in mkIf (desktop.wm == "i3") (switchSystem system {
    linux.services.xserver.windowManager.i3.enable = true;
    linux.custom.user.configFile."i3/config".text = with pkgs; ''
        exec --no-startup-id nm-applet
        exec --no-startup-id steam -silent
        exec --no-startup-id blueman-applet
        exec --no-startup-id udiskie --tray
        exec --no-startup-id discord --start-minimized
        exec --no-startup-id ${pkgs.feh}/bin/feh ~/Images/Wallpapers \
            --no-fehbg --bg-max --randomize
        exec_always --no-startup-id ${pkgs.autotiling}/bin/autotiling
        exec_always xset dpms 0 0 300
        exec_always ${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock --\
            i3lock -n -c ${theme.colors.bg}

        gaps inner ${toString (theme.gapSize * 3)}
        font pango:sans 10
        title_align center
        for_window [all] title_window_icon padding 10
        for_window [all] border normal ${builtins.toString theme.borderWidth}
        bar {
            status_command i3status
        }
        focus_follows_mouse no
        focus_wrapping no
        focus_on_window_activation focus
    ''
    + (with theme.colors; ''
            #border       bg            text   indicator     child_border
        client.focused \
            #${main}      #${main}      #${bg} #${main}      #${main}
        client.urgent \
            #${brightred} #${brightred} #${bg} #${brightred} #${brightred}
        client.focused_inactive \
            #${fg}        #${fg}        #${bg} #${fg}        #${fg}
        client.unfocused \
            #${fg}        #${fg}        #${bg} #${fg}        #${fg}
    '')
    + ''
        set $mod Mod4
        set $kill ${killScript}

        bindsym $mod+Shift+r restart
        bindsym $mod+Shift+e exec "i3-msg exit"

        bindsym $mod+Return exec i3-sensible-terminal
        bindsym $mod+space exec rofi -show drun
        bindsym $mod+c exec rofi -show calc
        bindsym $mod+e exec rofi -show emoji
        bindsym $mod+b exec rofi-bluetooth -show emoji

        set $refresh_i3status killall -SIGUSR1 i3status
        bindsym XF86AudioRaiseVolume exec \
            pactl set-sink-volume @DEFAULT_SINK@ +5% && $refresh_i3status
        bindsym XF86AudioLowerVolume exec \
            pactl set-sink-volume @DEFAULT_SINK@ -5% && $refresh_i3status
        bindsym Shift+XF86AudioRaiseVolume exec \
            ${playerctl}/bin/playerctl volume 0.05+
        bindsym Shift+XF86AudioLowerVolume exec \
            ${playerctl}/bin/playerctl volume 0.05-
        bindsym XF86AudioPlay exec \
            ${playerctl}/bin/playerctl play-pause
        bindsym XF86AudioNext exec \
            ${playerctl}/bin/playerctl next
        bindsym XF86AudioPrev exec \
            ${playerctl}/bin/playerctl previous
        bindsym Shift+XF86AudioPlay exec \
            ${playerctl}/bin/playerctl shuffle toggle

        bindsym $mod+d exec dunstctl close
        bindsym $mod+Shift+d exec dunstctl history-pop
        bindsym $mod+o exec dunstctl action

        bindsym $mod+q exec $kill

        bindsym $mod+h focus left
        bindsym $mod+j focus down
        bindsym $mod+k focus up
        bindsym $mod+l focus right

        bindsym $mod+Shift+h move left
        bindsym $mod+Shift+j move down
        bindsym $mod+Shift+k move up
        bindsym $mod+Shift+l move right

        bindsym $mod+f fullscreen toggle

        bindsym $mod+Shift+space floating toggle
        bindsym $mod+Tab focus mode_toggle
        floating_modifier Ctrl

        bindsym $mod+r mode "resize"
        mode "resize" {
            bindsym h resize shrink width  5 px
            bindsym j resize shrink height 5 px
            bindsym k resize grow   height 5 px
            bindsym l resize grow   width  5 px

            bindsym Escape mode "default"
            bindsym $mod+r mode "default"
        }
    ''
    + (concatMapStringsSep "\n" (x: let n = toString x; in ''
        set $ws${n} "${n}"
        bindsym $mod+${n} workspace number $ws${n}
        bindsym $mod+Shift+${n} move container to workspace number $ws${n}
    '') [1 2 3 4 5 6 7 8])
    + ''
        set $ws9 "9"
        bindsym $mod+9 workspace number $ws9
        bindsym $mod+Shift+minus move container to workspace number $ws9
        set $ws10 "10"
        bindsym $mod+0 workspace number $ws10
        bindsym $mod+Shift+plus move container to workspace number $ws10
    '';
})
