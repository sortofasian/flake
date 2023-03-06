{ pkgs, ... }:
{
    hardware = {
        cpu.amd.updateMicrocode = true;
        nvidia = {
            modesetting.enable = true;
            open = true;
        };
        opengl = {
            enable = true;
            extraPackages = with pkgs; [
                vaapiVdpau
                libvdpau-va-gl
            ];
        };
        bluetooth.enable = true;
        bluetooth.package = pkgs.bluezFull;
    };

    boot.kernel.sysctl = {
        "vm.max_map_count" = 16777216;
        "net.ipv4.neigh.default.gc_thresh1" = 32768;
        "net.ipv4.neigh.default.gc_thresh2" = 65536;
        "net.ipv4.neigh.default.gc_thresh3" = 131072;
    };

    environment.sessionVariables = {
        DXVK_ASYNC = "1";
        VKD3D_CONFIG = "dxr11";
        PROTON_ENABLE_NVAPI = "1";
        PROTON_HIDE_NVIDIA_GPU = "0";
        STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge}";
    };

    programs = {
        gamemode.enable = true;
    };

    networking.extraHosts = '' 
        # EAC Workaround for Star Citizen
        127.0.0.1 modules-cdn.eac-prod.on.epicgames.com

        # Disable miHoYo logging
        0.0.0.0 sg-public-data-api.hoyoverse.com
        0.0.0.0 log-upload-os.hoyoverse.com
        0.0.0.0 overseauspider.yuanshen.com
    '';
}
