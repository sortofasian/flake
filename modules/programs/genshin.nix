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
        programs.anime-game-launcher.enable = true;
        nix.settings.substituters = ["https://ezkea.cachix.org"];
        nix.settings.trusted-public-keys = ["ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="];
    };
}
