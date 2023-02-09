{
    inputs.fu.url = "github:numtide/flake-utils";
    inputs.charie.url = "github:sortofasian/flake";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    outputs = { self, nixpkgs, charlie, fu }:
    fu.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
        inherit (import charlie.lib { inherit pkgs; }) symlinkJoin;
    in {
        defaultPackage = symlinkJoin {
            name = "shell";
            paths = with pkgs; [ ];
        };
    });
}
