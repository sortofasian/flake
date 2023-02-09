{ pkgs, lib, symlinkJoin, makeWrapper, writeText, writeShellScript }:
let
    config = writeText "i3" (''
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
        (lib.filesystem.listFilesRecursive ./config)));
in symlinkJoin {
    name = "i3";
    paths = [ pkgs.i3 ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/i3 --add-flags "-c ${config}"
    '';
}
