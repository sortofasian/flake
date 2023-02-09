{ 
    inputs.fu.url = "github:numtide/flake-utils";

    outputs = { fu, nixpkgs, ... }:
    fu.lib.eachDefaultSystemMap (system: let
        pkgs = import nixpkgs { inherit system; };
    in (import ./. { inherit pkgs; })
    );
}
