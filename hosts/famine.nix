{ pkgs, ... }:
{
    users.users.charlie.packages = with pkgs; [
        orchis-theme
        capitaine-cursors
        lxappearance

        rofi

        cider
        lutris
        discord
        firefox
        blender
        obsidian
        lug-helper
        unityhub
    ];

    services = {
        picom = {
            settings = {
                shadow = true;
                shadow-opacity = 0.30;
                shadow-radius = 20;
                shadow-offset-x = -20;
                shadow-offset-y = -20;
                corner-radius = 10;
                blur = {
                    method = "gaussian";
                    size = 40;
                    deviation = 5.0;
                };
                blur-background = true;
                blur-background-frame = true;
            };
        };
    };

    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };
}
