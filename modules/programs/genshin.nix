{ pkgs, lib, config, system, ... }: let
    inherit (builtins)
        fetchTarball;
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        genshin;
in switchSystem system { linux = {
    options.custom.genshin.enable = mkOption {
        type = types.bool;
        default = false;
    };

    imports = let
        aagl = import (fetchTarball {
            url = "https://github.com/ezKEa/aagl-gtk-on-nix/archive/main.tar.gz";
            sha256 = "1wx7lvy2dzhnzg9n62bmca0yiwk6wzpal4hsr2xx9xnr2z27khxz";
        }) { inherit pkgs; };
    in [ aagl.module ];

    config = mkIf genshin.enable {
        programs.an-anime-game-launcher.enable = true;
    };
}; }
