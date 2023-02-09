{ pkgs, lib, symlinkJoin, makeWrapper, writeText }:
let
    inherit (lib.generators) toINI;
    config = writeText "dunst.ini" (toINI {} (import ./config.nix));
in symlinkJoin {
    name = "dunst";
    paths = [ pkgs.dunst ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/dunst --add-flags "-config ${config}"
    '';
}
