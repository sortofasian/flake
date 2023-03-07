{ lib, ... }: let
    inherit (lib)
        filter
        flatten
        hasSuffix
        pathExists
        mapAttrsToList;
    inherit (lib.custom)
        importDir;
    inherit (builtins)
        readDir;
in {
    importDir = dir: flatten (
        filter (v: v != null)
        (mapAttrsToList
            (file: type:
                let path = "${dir}/${file}"; in
                if type == "directory"
                    then if pathExists "${path}/default.nix"
                        then import path
                        else importDir path
                else if type == "regular"
                && file != "default.nix"
                && hasSuffix ".nix" file
                    then import path
                else null)
            (readDir dir)
        )
    );
}
