{ lib, ... }: let
    inherit (lib)
        hasInfix;
    inherit (lib.custom)
        switch;
in {
    # WARNING: TODO: There's something wrong here but I don't know what
    # Something to do with switchSystem returning null not playing well
    # with mkMerge; fixed by returning empty set instead
    switchSystem = system: {linux ? {}, darwin ? {}}:
        switch system (v: c: hasInfix c v) { inherit linux darwin; };
}
