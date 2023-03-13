{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        mkMerge;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        desktop;
in {
    config.fonts = mkIf desktop.enable (mkMerge [
        {
            fontDir.enable = true;
            fonts = with pkgs; [
                (nerdfonts.override {fonts = [ "FiraCode" "Noto" ]; })
                noto-fonts
                noto-fonts-emoji
                noto-fonts-cjk-sans
                noto-fonts-cjk-serif
            ];
        }
        (switchSystem system { linux = {
            enableDefaultFonts = false;
            fontconfig.defaultFonts = {
                emoji = ["Noto Color Emoji"];
                serif = ["Noto Serif Nerd Font"];
                sansSerif = ["Noto Sans Nerd Font"];
                monospace = ["FiraCode Nerd Font Mono"];
            };
        }; })
    ]);
}
