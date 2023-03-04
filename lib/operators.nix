{ lib, ... }: let
    inherit (lib)
        fold
        filter
        hasInfix
        findSingle
        mapAttrsToList;

    inherit (lib.attrsets)
        recursiveUpdate;
in rec {
    # WARNING Don't use "null" as a return value as it is
    # used to filter out non-matching cases
    # it was either not using the string null or not using null
    # (or maybe i need more experience)
    switch = (value: pred: cases:
    findSingle
        (_: true)
        (abort "No matching case")
        (abort "Multiple matching cases") 
        (filter
            (v: v != "null")
            (mapAttrsToList
                (case: return:
                    if (pred value case)
                        then return
                    else "null")
                cases
            )
        )
    );
    switchSystem = system: {linux ? null, darwin ? null}:
        switch system (v: c: hasInfix c v) { inherit linux darwin; };

    merge = sets: fold (x: y: recursiveUpdate x y) {} sets;
}
