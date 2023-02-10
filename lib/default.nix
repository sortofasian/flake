{ pkgs }:
{
    symlinkJoin = pkgs.callPackage ./symlinkJoin.nix {};
}

