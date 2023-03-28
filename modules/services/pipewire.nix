{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user
        audio
        desktop;
in switchSystem system { linux = {
    options.custom.audio.enable = mkOption {
        type = types.bool;
        default = desktop.enable;
    };

    config = mkIf audio.enable {
        security.rtkit.enable = true;
        services.pipewire = {
            enable = true;
            wireplumber.enable = true;
            pulse.enable = true;
            jack.enable = true;
            alsa.enable = true;
        };
        users.users.${user.name}.packages = with pkgs; [
            pavucontrol
            pulseaudio
        ];
    };
}; }
