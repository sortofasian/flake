{
    custom = {
        user.name = "charlie";
        age.systemIdentity.file = ./systemIdentity.age;
    };
    fileSystems."/" = {
        device = "/dev/disk/by-partlabel/nixos";
        fsType = "ext4";
    };
    fileSystems."/boot/efi" = {
        device = "/dev/disk/by-partlabel/boot";
        fsType = "vfat";
    };
    swapDevices = [{
        device = "/dev/disk/by-partlabel/swap";
    }];

    imports = [ ./shadowsocks.nix ];
}
