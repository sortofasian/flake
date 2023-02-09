{ pkgs, ... }:
{
    system.autoUpgrade = {
        enable = true;
        dates = "daily";
        allowReboot = true;
        rebootWindow.lower = "02:00";
        rebootWindow.upper = "06:00";
    };

    nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    boot.loader = {
        timeout = 1;
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };
        systemd-boot = {
            enable = true;
            configurationLimit = 1;
            consoleMode = "max";
            editor = false;
        };
    };

    networking = {
    #    useDHCP = true;
        networkmanager.enable = true;
    };

    services.journald.extraConfig = "SystemMaxUse=500M";

    environment.sessionVariables = {
        WINEPREFIX    = "$XDG_DATA_HOME/wine";
        #XAUTHORITY    = "$XDG_RUNTIME_DIR/.Xauthority"; issue with lightdm
        XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/xcompose";
        XCOMPOSEFILE  = "$XDG_RUNTIME_DIR/X11/xcompose";
        ERRFILE       = "$XDG_CACHE_HOME/X11/xsession-errors";

        __GL_SHADER_DISK_CACHE      = "1";
        CUDA_CACHE_PATH             = "$XDG_CACHE_HOME/nv";
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nvidia";

    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    users = {
        users.charlie = {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            shell = pkgs.fish;
        };
    };

    fonts = {
        enableDefaultFonts = false;
        fontconfig.defaultFonts = {
            emoji = ["Noto Color Emoji"];
            serif = ["Noto Serif Nerd Font"];
            sansSerif = ["Noto Sans Nerd Font"];
            monospace = ["FiraCode Nerd Font Mono"];
        };
    };

    programs = {
        dconf.enable = true;
        seahorse.enable = true;
        gnupg.agent.pinentryFlavor = "qt";
        hyprland.enable = true;
        hyprland.nvidiaPatches = true;
    };

    services = {
        gnome.gnome-keyring.enable = true;
    };
}
