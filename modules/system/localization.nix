{ lib, config, system, ...}: let
    inherit (lib)
        mkDefault;
    inherit (lib.custom)
        switchSystem;
in switchSystem system { linux = {
    time.timeZone = mkDefault "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
}; }
