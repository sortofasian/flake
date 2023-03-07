{ lib, ... }: let
    inherit (lib)
        hasInfix;
    inherit (lib.custom)
        switch;
in {
    switchSystem = system: {linux ? null, darwin ? null}:
        switch system (v: c: hasInfix c v) { inherit linux darwin; };
}
