{ pkgs, config, ... }:
{
    custom.user.name = "charlie";
    users.users.charlie.packages = with pkgs; [
        rofi
        dunst

        orchis-theme
        capitaine-cursors
    ];
}
