{ pkgs, config, inputs, ... }:
{
    networking.firewall.enable = false;
    boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    boot.supportedFilesystems = ["ntfs"];

    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };

    services = {
        gnome.gnome-keyring.enable = true;
        tailscale.enable = true;
        udev.packages = [ pkgs.qmk-udev-rules ];
    };

    custom = {
        bluetooth.enable = true;
        cpu = "amd";
        gpu = "nvidia";
        cuda.enable = true;
        virtualisation.enable = true;

        user.name = "charlie";
        desktop = {
            enable = true;
            wm = "hyprland";
        };
        theme.colorscheme = "shadotheme";

        neovim.enable = true;
        #neovim.dev = true;
        # alacritty.enable = false;
        # kitty.enable = true;
        dunst.enable = true;
        # rofi.enable = true;
        #direnv.enable = true;
        networkmanager.enable = true;
        audio.enable = true;
        udisks.enable = true;

        gaming.enable = true;
        steam = true;
        star-citizen.enable = true;
        #genshin.enable = true;
    };

    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
        gcc
        clang
        protontricks
        gnome.nautilus
        orchis-theme
        capitaine-cursors
        lxappearance

        prusa-slicer
        gparted
        ledger-live-desktop
        protonup-qt
        protonvpn-gui
        parsec-bin
        obs-studio
        imv
        mpv
        gimp
        kicad
        cider
        kicad
        lutris
        sioyek
        spotify
        libreoffice
        google-chrome
        blender
        #obsidian
        swww
        eww
        prismlauncher
        #yuzu-early-access
        (discord.override { withVencord = true; })
        vesktop
        inputs.np-master.legacyPackages.${system}.xwaylandvideobridge

        rustup
    ];
    environment.variables = with config.custom; {
        "RUSTUP_HOME" = "${xdg.data}/rustup";
        "CARGO_HOME" = "${xdg.data}/cargo";
        "NPM_CONFIG_USERCONFIG" = "${xdg.config}/npm/npmrc";
        "GTK2_RC_FILES" = "${xdg.config}/gtk-2.0/gtkrc";
    };
    custom.user.configFile."npm/npmrc".text = with config.custom; ''
        prefix=${xdg.data}/npm
        cache=${xdg.cache}/npm
        init-module=${xdg.config}/npm/config/npm-init.js
    '';
}
