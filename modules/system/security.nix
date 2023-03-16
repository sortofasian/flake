{ lib, config, system, ... }: let
    inherit (lib)
        mkIf
        mkMerge;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        desktop;
in switchSystem system { linux = mkMerge [
    (mkIf desktop.enable {
        programs.gnupg.agent.pinentryFlavor = "qt";
        services.gnome.gnome-keyring.enable = true;
        programs.seahorse.enable = true;
    })
    {
        programs.gnupg.agent.enable = true;
        hardware.gpgSmartcards.enable = true;
        environment.variables.GNUPGHOME = "$XDG_DATA_HOME/gnupg";
    }
]; }
