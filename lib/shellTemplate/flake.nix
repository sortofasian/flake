{
    inputs.fu.url = "github:numtide/flake-utils";
    inputs.flake.url = "github:sortofasian/flake";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

    outputs = { self, nixpkgs, flake, fu }:
    fu.lib.eachDefaultSystem (system: let
        pkgs = import nixpkgs { inherit system; };
    in {
        defaultPackage = pkgs.symlinkJoin {
            name = "shell";
            paths = with pkgs; [ ];
        };
    });
}
