{ pkgs, lib, system, ... }: let
    inherit (lib.custom)
        switchSystem;

    commonConfig = {
        fontDir.enable = true;
        packages = with pkgs; [
            (nerdfonts.override {fonts = [ "FiraCode" "Noto" ]; })
            corefonts
            noto-fonts
            noto-fonts-emoji
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
        ];
    };
in {
    config.fonts = switchSystem system {
        linux = commonConfig // {
            enableDefaultPackages = false;
            fontconfig.defaultFonts = {
                emoji = ["Noto Color Emoji"];
                serif = ["Noto Serif Nerd Font"];
                sansSerif = ["Noto Sans Nerd Font"];
                monospace = ["FiraCode Nerd Font Mono"];
            };
        };
        darwin = commonConfig;
    };
}
