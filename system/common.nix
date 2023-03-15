{ pkgs, lib, inputs, system, ... }: let
    inherit (lib)
        mkDefault;
    inherit (lib.custom)
        importDir;
    inherit (inputs)
        nixpkgs;
in {
    nixpkgs.hostPlatform = system;
    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
    nix.gc.automatic = mkDefault true;
    nix.settings = {
        experimental-features = [ "flakes" "nix-command" ];
        auto-optimise-store = mkDefault true;
    };
    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

    imports = importDir ../config;
}
