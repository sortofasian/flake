{ lib, ... }: let
    inherit (lib.custom)
        systemSpecificLib;
in {
    systemLib = systemSpecificLib (args: {}
        // (import ./copyDir.nix args)
    );
}
