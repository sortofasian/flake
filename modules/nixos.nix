{ pkgs, ... }:
{
    environment.sessionVariables = {
        WINEPREFIX    = "$\{XDG_DATA_HOME}/wine";
        #XAUTHORITY    = "$XDG_RUNTIME_DIR/.Xauthority"; issue with lightdm
    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    services = {
        clamav.daemon.enable = true;
        clamav.updater.enable = true;
    };
}
