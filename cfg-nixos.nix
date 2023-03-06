{ lib, pkgs, ... }: let
    inherit (lib)
        mkDefault;
    inherit (lib.custom)
        flakePath;
in {
    system.stateVersion = "22.11";

    system.autoUpgrade = {
        enable = mkDefault true;
        flake = "${flakePath}";
        dates = "daily";
        allowReboot = true;
        rebootWindow.lower = "02:00";
        rebootWindow.upper = "06:00";
    };

    fileSystems."/" = mkDefault {
        device = "/dev/disk/by-partlabel/nixos";
        fsType = "ext4";
    };
    fileSystems."/boot/efi" = mkDefault {
        device = "/dev/disk/by-partlabel/boot";
        fsType = "vfat";
    };
    swapDevices = mkDefault [{
        device = "/dev/disk/by-partlabel/swap";
    }];

    boot = {
        kernelPackages = mkDefault pkgs.linuxKernel.packages.linux_6_2;
        loader = {
            timeout = 1;
            efi.canTouchEfiVariables = mkDefault true;
            efi.efiSysMountPoint = mkDefault "/boot/efi";
            systemd-boot = {
                enable = mkDefault true;
                consoleMode = "max";
                editor = false;
            };
        };
    };

    networking.networkmanager.enable = mkDefault true;

    services.pcscd.enable = true;
}
