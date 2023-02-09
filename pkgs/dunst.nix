{ pkgs, lib, symlinkJoin, makeWrapper }:
let
    inherit (lib.generators) toINI;
    config = toINI {} {
    };
in symlinkJoin {
    name = "dunst";
    paths = [ pkgs.dunst ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/dunst --add-flags "-config ${config}"
    '';
}
