{ pkgs, lib, ... }: let
    inherit (pkgs)
        writeShellScript;
in {
    config.custom.user.configFile."i3/config".text = ''
        set $kill ${writeShellScript "closewindow" ''
            id=$(xdotool getactivewindow)
            class=$(xprop -id $id WM_CLASS)
            if [[ $class = *"Steam"* ]]; then
                xdotool windowunmap $id
                exit
            else
                i3-msg kill
                exit
            fi
        ''}
        ''\n
    ''
    + (lib.concatMapStrings
        builtins.readFile
        (lib.filesystem.listFilesRecursive ./config));
}
