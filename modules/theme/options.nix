{ lib, config, ... }: let
    inherit (builtins)
        readDir;
    inherit (lib)
        types
        mkOption
        removeSuffix
        mapAttrsToList;
in {
    options.custom.theme = {
        colorscheme = mkOption {
            type = types.nullOr (types.enum (mapAttrsToList
                (name: _: removeSuffix ".nix" name)
                (readDir ./colorschemes)
            ));
            default = null;
        };

        colors = let
            mkColor = default: mkOption { type = types.str; inherit default; };
        in {
            red           = mkColor "f7768e";
            yellow        = mkColor "e0af68";
            green         = mkColor "9ece6a";
            cyan          = mkColor "449dab";
            blue          = mkColor "7aa2f7";
            magenta       = mkColor "ad8ee6";
            white         = mkColor "9699a8";
            black         = mkColor "32344a";
            brightred     = mkColor "ff7a93";
            brightyellow  = mkColor "ff9e64";
            brightgreen   = mkColor "b9f27c";
            brightcyan    = mkColor "0db9d7";
            brightblue    = mkColor "7da6ff";
            brightmagenta = mkColor "bb9af7";
            brightwhite   = mkColor "acb0d0";
            brightblack   = mkColor "444b6a";
        };

        opacity = mkOption { type = types.float; default = 0.9; };

        shadows = {
            enable   = mkOption { type = types.bool; default = true; };
            opacity  = mkOption { type = types.float; default = 0.3; };
            radius   = mkOption { type = types.int; default = 20; };
            offset-x = mkOption { type = types.int; default = -20; };
            offset-y = mkOption { type = types.int; default = -20; };
        };

        gapSize      = mkOption { type = types.int; default = 10; };
        cornerRadius = mkOption { type = types.int; default = 10; };

        blur.enable = mkOption { type = types.bool; default = true; };
        blur.radius = mkOption { type = types.int; default = 40; };
    };
}
