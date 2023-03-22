{ lib, config, ... }: let
    inherit (lib)
        mkIf;
    inherit (config.custom)
        theme;
in {
    config.custom.theme.colors = mkIf (theme.colorscheme == "tokyonight") {
        red           = "f7768e";
        yellow        = "e0af68";
        green         = "9ece6a";
        cyan          = "449dab";
        blue          = "7aa2f7";
        magenta       = "ad8ee6";
        white         = "9699a8";
        black         = "32344a";
        brightred     = "ff7a93";
        brightyellow  = "ff9e64";
        brightgreen   = "b9f27c";
        brightcyan    = "0db9d7";
        brightblue    = "7da6ff";
        brightmagenta = "bb9af7";
        brightwhite   = "acb0d0";
        brightblack   = "444b6a";
    };
}
