{ pkgs, lib, modulesPath, config, inputs, ... }:
 {

    imports = [inputs.apple-silicon.nixosModules.default];

    nixpkgs.hostPlatform = "aarch64-linux";
    hardware.asahi.peripheralFirmwareDirectory = ./firmware;

    custom.user.name = "charlie";
    custom.age.enable = false;
    custom.neovim.enable = true;

    boot.zfs.forceImportRoot = false;
    boot.supportedFilesystems = ["zfs"];
    boot.zfs.extraPools = ["mutable"];
    networking.hostId = "3b82b05e";

    services.openssh.enable = true;

    users.mutableUsers = true;
    users.users.charlie = {
        uid = 1000;
        name = "charlie";
        group = "users";
        isNormalUser = true;
        extraGroups = ["wheel" "dialout" ];
        password = "01261461";
    };
}
