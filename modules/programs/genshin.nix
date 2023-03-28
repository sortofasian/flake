{ lib, config, system, inputs, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        genshin;
    inherit (inputs)
        aagl;
in switchSystem system {
    linux.imports = [aagl.nixosModules.default];

    linux.options.custom.genshin.enable = mkOption {
        type = types.bool;
        default = false;
    };

    linux.config = mkIf genshin.enable {
        programs.an-anime-game-launcher.enable = true;
        nix.settings = aagl.nixConfig;
    };
}
