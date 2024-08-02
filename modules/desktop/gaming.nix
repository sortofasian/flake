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
            hardware.steam-hardware.enable = true;
            environment.variables = {
                STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.stdenv.mkDerivation rec {
                    pname = "proton-ge";
                    version = "GE-Proton8-21";
                    src = builtins.fetchurl {
                        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases" 
                            + "/download/${version}/${version}.tar.gz";
                        sha256 = "12iv2m85jw1qcmssq6k9xyqhkkccwwy2440w2yina5j6qyjv2yfx";
                    };
                    buildCommand = ''
                        mkdir -p $out
                        tar -C $out --strip=1 -x -f $src
                    '';
                }}";
            };
        })

        {
            programs.gamemode.enable = true;
            environment.variables = {
                DXVK_ASYNC = "1";
                VKD3D_CONFIG = "dxr11";
            };
        }
    ]);
}; }
