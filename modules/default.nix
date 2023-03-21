{ lib, ... }: let
    modules = dir: lib.flatten (builtins.filter (v : v != null)
    (lib.mapAttrsToList
        (file: type: let path = "${dir}/${file}"; in
            if type == "directory"
                then if lib.pathExists "${path}/default.nix"
                    then path
                    else modules path
            else if type == "regular"
            && file != "default.nix"
            && lib.hasSuffix ".nix" file
                then path
            else null
        )
        (builtins.readDir dir)
    ));
in { imports = modules ./.; }
