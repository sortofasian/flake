{
    inputs.fu.url = "github:numtide/flake-utils";
    inputs.flake.url = "github:sortofasian/flake";

    outputs = { self, nixpkgs, flake, fu }:
    fu.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
        inherit (flake.lib { inherit pkgs; }) symlinkJoin;
    in {
        defaultPackage = symlinkJoin {
            name = "shell";
            paths = with pkgs; [
            ];
        };
    });
}
