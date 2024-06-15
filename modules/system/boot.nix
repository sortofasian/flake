{ lib, system, config, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption
        mkDefault;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        bootMode;
in switchSystem system { linux = {
    options.custom = {
        bootMode = mkOption {
            type = types.enum [ "legacy" "uefi" ];
            default = "uefi";
        };
        swapSize = mkOption {
            type = types.str;
            default = "0";
        };
    };

    config = {
        hardware.enableAllFirmware = true;
        hardware.enableRedistributableFirmware = true;

        fileSystems."/boot/efi" = mkIf (bootMode == "uefi") (mkDefault {
            device = "/dev/disk/by-label/BOOT";
            fsType = "vfat";
        });
        fileSystems."/" = mkDefault {
            device = "/dev/disk/by-label/nixos";
            fsType = "ext4";
        };
        #swapDevices = mkDefault [{
        #    device = "/dev/disk/by-label/swap";
        #}];

        boot.initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "sd_mod"
        ];
        boot.loader = mkMerge [
            { timeout = 1; }
            (mkIf (bootMode == "uefi") {
                efi.canTouchEfiVariables = mkDefault true;
                efi.efiSysMountPoint = mkDefault "/boot/efi";
                systemd-boot = {
                    enable = true;
                    consoleMode = "max";
                    editor = false;
                };
            })
            (mkIf (bootMode == "legacy") {
                grub.enable = true;
                grub.devices = [ "/dev/sdd" ];
            })
        ];

        services.journald.extraConfig = "SystemMaxUse=500M";
    };
}; }
