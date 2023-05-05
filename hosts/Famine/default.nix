{ pkgs, ... }:
{
    custom = {
        user.name = "charlie";
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
        gpu = "nvidia";
        cuda.enable = true;

        neovim.enable = true;
        neovim.dev = true;
        # alacritty.enable = true;
        dunst.enable = true;
        genshin.enable = true;
        # git.enable = true;
        # rofi.enable = true;
        direnv.enable = true;
        star-citizen.enable = true;
        networkmanager.enable = true;
        audio.enable = true;
        udisks.enable = true;
        theme.colorscheme = "shadotheme";
    };

    environment.systemPackages = with pkgs; [
        orchis-theme
        capitaine-cursors
        lxappearance

        imv
        mpv
        cider
        kicad
        lutris
        sioyek
        firefox
        blender
        clockify
        #obsidian
        prismlauncher
        (discord.override { withOpenASAR = true; })
    ];

    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };
}
