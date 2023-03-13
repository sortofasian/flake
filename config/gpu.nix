{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        xdg
        gpu;
in switchSystem system { linux = {
    options.custom.gpu = mkOption {
        type = types.nullOr (types.enum [ "nvidia" ]);
        default = null;
    };

    config = mkMerge [
        (mkIf (gpu == "nvidia") {
            services.xserver.videoDrivers = [ "nvidia" ];
            environment.variables = {
                __GL_SHADER_DISK_CACHE      = "1";
                __GL_SHADER_DISK_CACHE_PATH = "${xdg.cache}/nv";
                CUDA_CACHE_PATH = "${xdg.cache}/nv";
            };
            hardware.nvidia = {
                modesetting.enable = true;
                open = true;
            };
        })
        ({
            hardware.opengl.enable = true;
            hardware.opengl.extraPackages = with pkgs; [
                vaapiVdpau
                libvpdau-va-gl
            ];
        })
    ];
}; }
