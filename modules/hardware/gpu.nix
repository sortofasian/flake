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

                GBM_BACKEND = "nvidia-drm";
                __GLX_VENDOR_LIBRARY_NAME = "nvidia";
                LIBVA_DRIVER_NAME="nvidia";
                __GL_GSYNC_ALLOWED="1";
                __GL_VRR_ALLOWED="0";
                GDK_BACKEND="wayland,x11";
                QT_QPA_PLATFORM="wayland;xcb";
                SDL_VIDEODRIVER="wayland,x11";
                CLUTTER_BACKEND="wayland";
                XDG_CURRENT_DESKTOP="Hyprland";
                XDG_SESSION_TYPE="wayland";
                XDG_SESSION_DESKTOP="Hyprland";
                QT_AUTO_SCREEN_SCALE_FACTOR="1";
                QT_WAYLAND_DISABLE_WINDOWDECORATION="1";
                NIXOS_OZONE_WL="1";
            };
            hardware.nvidia = {
                open = true;
                nvidiaSettings = true;
                modesetting.enable = true;
            };
            boot.kernelParams = [ "module_blacklist=amdgpu" ];
        })
        (mkIf (gpu != null) {
            hardware.opengl = {
                enable = true;
                driSupport = true;
                driSupport32Bit = true;
                extraPackages = with pkgs; [
                    vaapiVdpau
                    libvdpau-va-gl
                ];
            };
        })
    ];
}; }
