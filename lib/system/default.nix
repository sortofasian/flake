{ lib, ... }: let
    inherit (lib.custom)
        systemSpecificLib;
in {
    system = systemSpecificLib (args: {}
        // (import ./copyDir.nix args)
        // (import ./mkHost.nix args)
    );
}
