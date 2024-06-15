{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        desktop;
in mkIf (desktop.wm == "hyprland") (switchSystem system {
    linux = {
        programs.hyprland.enable = true;

        # https://github.com/NixOS/nixpkgs/issues/249645#issuecomment-1682226013
        xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

        systemd.user.targets.hyprland-session = {
            description = "Hyprland session";
            bindsTo = [ "graphical-session.target" ];
            wants = [ "graphical-session-pre.target" ];
            after = [ "graphical-session-pre.target" ];
        };

        custom.user.configFile."hypr/hyprpaper.conf".text = ''
            preload = ~/Images/Wallpapers/sky.png
            wallpaper = ,~/Images/Wallpapers/sky.png
        '';

        custom.user.configFile."hypr/hyprland.conf".text = with pkgs; ''
            windowrulev2 = float,class:^.{0}$,title:^.{0}$
            windowrulev2 = move 0 0,class:^.{0}$,title:^.{0}$
            windowrulev2 = noinitialfocus,class:^.{0}$,title:^.{0}$
            windowrulev2 = size 20 20,class:^.{0}$,title:^.{0}$

            monitor=DP-3,2560x1440@144,0x0,1
            monitor=HDMI-A-1,3840x2160@60,-2560x0,1.5

            exec-once = ${hyprpaper}/bin/hyprpaper
            exec-once = fish -c "steam -silent; swww init";
            exec-once = systemctl --user start hyprland-session.target

            env = XCURSOR_SIZE,24

            misc {
                vrr = 1
            }

            input {
                kb_layout = us
                kb_variant =
                kb_model =
                kb_options =
                kb_rules =


                touchpad {
                    natural_scroll = no
                }

                sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
                accel_profile = flat
            }

            general {
                gaps_in = 5
                gaps_out = 20
                border_size = 2
                col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
                col.inactive_border = rgba(595959aa)

                layout = dwindle
            }

            decoration {
                rounding = 10
                blur {
                    size = 3
                    passes = 1
                    new_optimizations = on
                }

                drop_shadow = yes
                shadow_range = 4
                shadow_render_power = 3
                col.shadow = rgba(1a1a1aee)
            }

            animations {
                enabled = yes

                bezier = myBezier, 0.05, 0.9, 0.1, 1.05

                animation = windows, 1, 7, myBezier
                animation = windowsOut, 1, 7, default, popin 80%
                animation = border, 1, 10, default
                animation = borderangle, 1, 8, default
                animation = fade, 1, 7, default
                animation = workspaces, 1, 6, default
            }

            dwindle {
                pseudotile = yes
                preserve_split = yes
            }

            master {
                new_is_master = true
            }

            gestures {
                workspace_swipe = off
            }

            $mainMod = SUPER

            bind = , XF86AudioRaiseVolume, exec, fish -c "pactl set-sink-volume @DEFAULT_SINK@ +5%"
            bind = , XF86AudioLowerVolume, exec, fish -c "pactl set-sink-volume @DEFAULT_SINK@ -5%"
            bind = , XF86AudioPlay, exec, fish -c "${playerctl}/bin/playerctl play-pause"
            bind = , XF86AudioNext, exec, fish -c "${playerctl}/bin/playerctl next"
            bind = , XF86AudioPrev, exec, fish -c "${playerctl}/bin/playerctl previous"
            bind = SHIFT, XF86AudioPlay, exec, fish -c "${playerctl}/bin/playerctl shuffle toggle"

            bind = $mainMod, d, exec, fish -c "dunstctl close"
            bind = $mainMod SHIFT, d, exec, fish -c "dunstctl history-pop"

            bind = $mainMod, return, exec, fish -c "kitty"
            bind = $mainMod, SPACE, exec, fish -c "rofi -show drun"
            bind = $mainMod, b, exec, fish -c "rofi-bluetooth"
            bind = $mainMod, e, exec, fish -c "rofi -show emoji"
            bind = $mainMod, q, killactive,
            bind = $mainMod SHIFT, q, exit,

            bind = $mainMod, f, fullscreen
            bind = $mainMod, V, togglefloating,
            bind = $mainMod, m, pseudo, # dwindle
            bind = $mainMod, comma, togglesplit, # dwindle

            # Move focus with mainMod + arrow keys
            bind = $mainMod, h, movefocus, l
            bind = $mainMod, l, movefocus, r
            bind = $mainMod, k, movefocus, u
            bind = $mainMod, j, movefocus, d

            bind = $mainMod, y, movewindow, l
            bind = $mainMod, o, movewindow, r
            bind = $mainMod, i, movewindow, u
            bind = $mainMod, u, movewindow, d

            # Switch workspaces with mainMod + [0-9]
            bind = $mainMod, 1, workspace, 1
            bind = $mainMod, 2, workspace, 2
            bind = $mainMod, 3, workspace, 3
            bind = $mainMod, 4, workspace, 4
            bind = $mainMod, 5, workspace, 5
            bind = $mainMod, 6, workspace, 6
            bind = $mainMod, 7, workspace, 7
            bind = $mainMod, 8, workspace, 8
            bind = $mainMod, 9, workspace, 9
            bind = $mainMod, 9, workspace, 9
            bind = $mainMod, 0, workspace, 10
            workspace=1,monitor:DP-1
            workspace=2,monitor:DP-1
            workspace=3,monitor:DP-1
            workspace=4,monitor:DP-1
            workspace=5,monitor:DP-1
            workspace=6,monitor:DP-1
            workspace=7,monitor:DP-1
            workspace=8,monitor:DP-1
            workspace=9,monitor:DP-1
            workspace=0,monitor:DP-1
            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            bind = $mainMod SHIFT, 1, movetoworkspace, 1
            bind = $mainMod SHIFT, 2, movetoworkspace, 2
            bind = $mainMod SHIFT, 3, movetoworkspace, 3
            bind = $mainMod SHIFT, 4, movetoworkspace, 4
            bind = $mainMod SHIFT, 5, movetoworkspace, 5
            bind = $mainMod SHIFT, 6, movetoworkspace, 6
            bind = $mainMod SHIFT, 7, movetoworkspace, 7
            bind = $mainMod SHIFT, 8, movetoworkspace, 8
            bind = $mainMod SHIFT, 9, movetoworkspace, 9
            bind = $mainMod SHIFT, 0, movetoworkspace, 10

            bind = $mainMod SHIFT, -, movetoworkspace, 9
            bind = $mainMod SHIFT, =, movetoworkspace, 10

            # Scroll through existing workspaces with mainMod + scroll
            bind = $mainMod, mouse_down, workspace, e+1
            bind = $mainMod, mouse_up, workspace, e-1

            # Move/resize windows with mainMod + LMB/RMB and dragging
            bindm = $mainMod, mouse:272, movewindow
            bindm = $mainMod, mouse:273, resizewindow
        '';

        # exec systemctl --user start hyprland-session.target
    };
})
