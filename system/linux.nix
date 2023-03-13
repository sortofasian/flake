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

    hardware.enableRedistributableFirmware = lib.mkDefault true;

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

    boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
    ];
    boot.loader = {
        timeout = 1;
        efi.canTouchEfiVariables = mkDefault true;
        efi.efiSysMountPoint = mkDefault "/boot/efi";
        systemd-boot = {
            enable = mkDefault true;
            consoleMode = "max";
            editor = false;
        };
    };

    services.journald.extraConfig = "SystemMaxUse=500M";
    services.pcscd.enable = true;
    services.gnome.gnome-keyring.enable = true;
}
