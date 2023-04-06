{ pkgs, config, ... }:
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
        theme.colorscheme = "tokyonight";
    };


    # Remnants of old config

    environment.systemPackages = with pkgs; [
        orchis-theme
        capitaine-cursors
        lxappearance

        cider
        lutris
        discord
        firefox
        blender
        obsidian
        prismlauncher

        unityhub
        jdk8
        (
            (callPackage
                (import
                    (pkgs.fetchFromGitHub {
                        owner = "tadfisher"; repo = "android-nixpkgs";
                        rev = "6e695622737d6068f4f6a3bfbb9a87ee738b47ab";
                        sha256 = "sha256-OCxvI6rxfHS4FpfXu6YDfO9FTFiz4E6iDk6pGvhnvas=";
                    })
                )
            { channel = "stable"; })
            .sdk (sdkPkgs: with sdkPkgs; [
                cmdline-tools-latest
                build-tools-33-0-2
                platform-tools
            ])
        )
        (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
                vscodevim.vim
                ms-dotnettools.csharp
            ]++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                    name = "tokyo-hack";
                    publisher = "ajshortt";
                    version = "0.3.2";
                    sha256 = "sha256-++ue0yAd/rnljsNPf++vsptoVxsKqyEgPVNDGWsA69o=";
                }
            ];
        })
    ];
    hardware.steam-hardware.enable = true;

    qt = {
        enable = true;
        platformTheme = "gtk2";
        style = "gtk2";
    };
}
