{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, darwin, ... } :

    let
        overlays = {pkgs, stable, ...}: { nixpkgs.overlays = [
            (import ./overlays.nix { inherit stable; inherit (pkgs) system; } )
        ];};
    in {
    };
}
