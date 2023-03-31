{ lib, pkgs, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        gpu;

in switchSystem system {
    linux.options.custom.cuda.enable = mkOption {
        type = types.bool;
        default = false;
    };
    linux.config = mkIf (gpu == "nvidia") {
        nix.settings = {
            substituters = [ "https://cuda-maintainers.cachix.org" ];
            trusted-public-keys = [(
                "cuda-maintainers.cachix.org-1:"
                + "0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
            )];
        };
        environment.systemPackages = with pkgs.cudaPackages; [
            cudatoolkit
        ];
    };
}
