{ system ? builtins.currentSystem, pkgs ? import <nixpkgs> { inherit system; } }:
{
    symlinkJoin = pkgs.callPackage ./symlinkJoin.nix {};
}
