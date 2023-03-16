{ lib, ... }: let
    inherit (lib)
        mkIf
        mkMerge
        filter
        findSingle
        mapAttrsToList;
in {
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

    mkSwitch = (value: pred: cases:
    mkMerge
        (mapAttrsToList
            (case: return:
                mkIf (pred value case) return)
            cases
        )
    );
}
