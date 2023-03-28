{ lib, ... }: let
    inherit (lib)
        fold;
    inherit (lib.attrsets)
        recursiveUpdate;
in {
    merge = sets: fold (x: y: recursiveUpdate x y) {} sets;
}
