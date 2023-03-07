{ pkgs, ... }:
{
    networking.hostName = "Famine";

    imports = [
        ./hardware-configuration.nix 
        ./system.nix
    ];
    
    users.users.charlie.packages = with pkgs; [
        feh
        playerctl
        autotiling
        pulseaudio

        orchis-theme
        capitaine-cursors

        dunst
        udiskie
        pavucontrol
        lxappearance
        networkmanagerapplet

        rofi

        cider
        (lutris.override {
            extraLibraries = pkgs: [ libnghttp2 ];
        })
        xdelta
        xterm
        gnome.zenity
        discord
        firefox
        blender
        obsidian
        lug-helper
        unityhub

        # idk what i needed these for?
        # using it for closing steam now ig
        xdotool
        #wtype
    ];

    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "charlie" ];

    programs.steam.enable = true;
    services = {
        udisks2.enable = true;
        blueman.enable = true;
        picom = {
            enable = true;
            settings = {
                backend = "glx";
                shadow = true;
                shadow-opacity = 0.30;
                shadow-radius = 20;
                shadow-offset-x = -20;
                shadow-offset-y = -20;
                use-damage = true;
                vsync = false;
                corner-radius = 10;
                blur = {
                    method = "gaussian";
                    size = 40;
                    deviation = 5.0;
                };
                blur-background = true;
                blur-background-frame = true;
                # window types: dock popup_menu dropdown_menu tooltip menu notification toolbar desktop
                blur-background-exclude = [
                    "window_type = 'dock'"
                    "window_type = 'toolbar'"
                    "window_type = 'desktop'"

                    "name = 'rofi - drun'"
                ];
                rounded-corners-exclude = [
                    "window_type = 'dock'"
                    "window_type = 'toolbar'"
                    "window_type = 'desktop'"
                ];
                shadow-exclude = [
                    "window_type = 'dock'"
                    "window_type = 'notification'"
                    "window_type = 'toolbar'"
                    "window_type = 'desktop'"

                    "name = 'rofi - drun'"
                ];
                wintypes = [
                ];
            };
        };
        xserver = {
            enable = true;
            layout = "us";
            xkbVariant = "";
            libinput.enable = true;
            libinput.mouse = {
                accelProfile = "flat";
                accelSpeed = "0";
            };
            autoRepeatDelay = 250;
            autoRepeatInterval = 20;
            updateDbusEnvironment = true;
            videoDrivers = ["nvidia"];
            excludePackages = with pkgs; [ dmenu ];
            windowManager.i3 = {
                enable = true;
                package = pkgs.i3;
            };
        };
        pipewire = {
            enable = true;
            audio.enable = true;
            wireplumber.enable = true;
            pulse.enable = true;
            jack.enable = true;
            alsa.enable = true;
        };
    };

    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };

    system.stateVersion = "22.11";
}
