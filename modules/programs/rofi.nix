{ lib, pkgs, config, system, ... }: let
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        theme;
in switchSystem system {
    linux.environment.systemPackages = [ (pkgs.rofi.override {
        plugins = with pkgs; [ rofi-calc rofi-emoji ];
    }) ];
    linux.custom.user.configFile."rofi/config.rasi".text = ''
        configuration {
            modes: [ drun, calc, emoji ];
            scroll-method: 0;
            drun-match-fields: [ name, generic, exec ];
            drun-display-format: "{name}";
        }

        * {
            red:           #${theme.colors.red};
            yellow:        #${theme.colors.yellow};
            green:         #${theme.colors.green};
            cyan:          #${theme.colors.cyan};
            blue:          #${theme.colors.blue};
            magenta:       #${theme.colors.magenta};
            white:         #${theme.colors.white};
            black:         #${theme.colors.black};
            brightred:     #${theme.colors.brightred};
            brightyellow:  #${theme.colors.brightyellow};
            brightgreen:   #${theme.colors.brightgreen};
            brightcyan:    #${theme.colors.brightcyan};
            brightblue:    #${theme.colors.brightblue};
            brightmagenta: #${theme.colors.brightmagenta};
            brightwhite:   #${theme.colors.brightwhite};
            brightblack:   #${theme.colors.brightblack};
        }

        window {
            font: "Sans 12";
            padding: ${builtins.toString theme.gapSize}px;
            border: 2px;
            border-radius: ${builtins.toString theme.cornerRadius}px;
            border-color: @white;
            background-color: @black;
            children: [ inputbar, listview, message ];
        }

        error-message { padding: ${builtins.toString theme.gapSize}px; }
        scrollbar { handle-width: 0px; }

        inputbar {
            padding: ${builtins.toString theme.gapSize};
            margin: 0px 0px ${builtins.toString theme.gapSize}px;
            border-radius: ${builtins.toString (theme.cornerRadius * 0.8)}px;
            background-color: @brightblack;
            color: @brightred;
            prompt: "";
            font: "Mono 12";
            children: [ entry ];
        }

        entry {
            placeholder: "";
            font:  inherit;
            color: inherit;
        }

        listview {
            border: 0px;
            background-color: @black;
            dynamic: false;
            lines: 10;
            columns: 10;
        }
        element {
            padding: ${builtins.toString (theme.gapSize * 0.3)}px;
            border-radius: ${builtins.toString (theme.cornerRadius * 0.4)}px;
            color: @foreground;
            font:inherit;
        }
        element-text,element-icon,element-index {
            background-color: inherit;
            text-color:       inherit;
            highlight: bold;
            horizontal-align: 0.5;
        }
        message {
            border: 0px;
            background-color: @brightblack;
            font: "Sans 8";
        }
    '';
}
