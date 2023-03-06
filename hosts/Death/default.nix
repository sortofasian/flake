{modulesPath, ...}:
{
    imports = [ (modulesPath + "/profiles/qemu-guest.nix")];

    services.spice-webdavd.enable = true;
    services.davfs2.enable = true;
    custom = {
        user.name = "charlie";
    };
}
