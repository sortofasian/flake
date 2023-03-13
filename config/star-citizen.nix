{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        star-citizen;
in switchSystem system { linux = {
    options.custom.star-citizen.enable = mkOption {
        type = types.bool;
        default = false;
    };

    config = mkIf star-citizen.enable {
        boot.kernel.sysctl = {
            "vm.max_map_count" = 16777216;
            "net.ipv4.neigh.default.gc_thresh1" = 32768;
            "net.ipv4.neigh.default.gc_thresh2" = 65536;
            "net.ipv4.neigh.default.gc_thresh3" = 131072;
        };

        networking.extraHosts = '' 
            # EAC Workaround for Star Citizen
            127.0.0.1 modules-cdn.eac-prod.on.epicgames.com
        '';
    };
}; }
