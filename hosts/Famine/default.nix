{ pkgs, config, ... }:
{
    custom = {
        user.name = "charlie";
        age.systemIdentity.file = ./systemIdentity.age;
        desktop = {
            enable = true;
            wm = "i3";
            compositor = "picom";
        };

        gaming.enable = true;
        steam = true;

        virtualisation.enable = true;

        bluetooth.enable = true;
        cpu = "amd";
   #     gpu = "nvidia";

        neovim.enable = true;
        # alacritty.enable = true;
        dunst.enable = true;
        genshin.enable = true;
        # git.enable = true;
        # rofi.enable = true;
        shell.enable = true;
        star-citizen.enable = true;
        networkmanager.enable = true;
        audio.enable = true;
        udisks.enable = true;
        theme.colorscheme = "tokyonight";
    };


    # Remnants of old config

    users.users.charlie.packages = with pkgs; [
        orchis-theme
        capitaine-cursors
        lxappearance

        cider
        lutris
        discord
        firefox
        blender
        obsidian
        unityhub
    ];

    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };
}
