{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        cpu;
in switchSystem system { linux = {
    options.custom.cpu = mkOption {
        type = types.nullOr (types.enum [ "amd" "intel" ]);
        default = null;
    };

    config = mkMerge [(mkIf (cpu != null) { hardware.cpu.${cpu}.updateMicrocode = true; })];
}; }
