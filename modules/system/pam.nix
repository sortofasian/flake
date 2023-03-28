{ lib, system, config, ... }: let
    inherit (lib)
        mkIf;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom.user)
        mkOutOfStoreSymlink;
    inherit (config.age)
        secrets;
in mkIf config.custom.age.enable (switchSystem system { linux = {
    # TODO: Figure out pam on darwin
    security.pam = {
        u2f.enable = true;
        u2f.cue = true;
        u2f.origin = "pam://sortofasian";
        services.login.u2fAuth = true;
        services.sudo.u2fAuth = true;
    };
    custom.user.configFile."Yubico/u2f_keys"
        .source = mkOutOfStoreSymlink secrets.pam-yubikeys.path;
}; })
