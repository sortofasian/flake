{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        desktop;
in mkIf (desktop.wm == "hyprland") (switchSystem system {
    linux = {
        programs.hyprland = {
            enable = true;
            enableNvidiaPatches = true;
        };
        # https://github.com/NixOS/nixpkgs/issues/249645#issuecomment-1682226013
        xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];

        systemd.user.targets.hyprland-session = {
            description = "Hyprland session";
            bindsTo = [ "graphical-session.target" ];
            wants = [ "graphical-session-pre.target" ];
            after = [ "graphical-session-pre.target" ];
        };

        # exec systemctl --user start hyprland-session.target
    };
})
