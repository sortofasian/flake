{ lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption
        hasInfix;
    inherit (lib.custom)
        switch;
    inherit (config.custom.xdg)
        enable;

    sessionVariables = {
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";
        XDG_BIN_HOME    = "$HOME/.local/bin";
    };

    variables = {
        __GL_SHADER_DISK_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
        HISTFILE        = "$XDG_DATA_HOME/bash/history";
        INPUTRC         = "$XDG_CONFIG_HOME/readline/inputrc";
        LESSHISTFILE    = "$XDG_CACHE_HOME/lesshst";
        WGETRC          = "$XDG_CONFIG_HOME/wgetrc";
    };

in {
    options.custom.xdg = {
        enable = mkOption {
            type = types.bool;
            default = true;
        };
    };

    config = mkIf enable {
        environment = switch system (val: case: hasInfix case val) {
            linux = {
                inherit sessionVariables variables;

                # Move ~/.Xauthority out of $HOME (setting XAUTHORITY early isn't enough)
                extraInit = ''
                    export XAUTHORITY=/tmp/Xauthority
                    [ -e ~/.Xauthority ] && mv -f ~/.Xauthority "$XAUTHORITY"
                '';
            };
            darwin = {
                variables = sessionVariables // variables;
            };
        };
    };
}
