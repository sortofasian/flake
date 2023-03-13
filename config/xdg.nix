{ lib, system, ... }: let
    inherit (lib.custom)
        switchSystem;
in {
    environment = let
        sessionVariables = {
            XDG_CACHE_HOME  = "$HOME/.cache";
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_DATA_HOME   = "$HOME/.local/share";
            XDG_STATE_HOME  = "$HOME/.local/state";
            XDG_BIN_HOME    = "$HOME/.local/bin";
        };

        variables = {
            HISTFILE        = "$XDG_DATA_HOME/bash/history";
            INPUTRC         = "$XDG_CONFIG_HOME/readline/inputrc";
            LESSHISTFILE    = "$XDG_CACHE_HOME/lesshst";
            WGETRC          = "$XDG_CONFIG_HOME/wgetrc";
        };
    in switchSystem system {
        linux = { inherit sessionVariables variables; };
        darwin = { variables = sessionVariables // variables; };
    };
}
