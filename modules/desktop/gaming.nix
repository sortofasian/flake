{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        gpu
        steam
        gaming;
in switchSystem system { linux = {
    options.custom.gaming.enable = mkOption {
        type = types.bool;
        default = false;
    };
    options.custom.steam = mkOption {
        type = types.bool;
        default = false;
    };

    config = mkIf gaming.enable (mkMerge [
        (mkIf (gpu == "nvidia") {
            environment.variables = {
                PROTON_ENABLE_NVAPI = "1";
                PROTON_HIDE_NVIDIA_GPU = "0";
            };
        })

        (mkIf steam {
            programs.steam.enable = true;
            # TODO: add proton-ge STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge}";
        })

        {
            programs.gamemode.enable = true;
            environment.sessionVariables = {
                DXVK_ASYNC = "1";
                VKD3D_CONFIG = "dxr11";
            };
        }
    ]);
}; }
