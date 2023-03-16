{ pkgs, lib, inputs, system, ... }: let
    inherit (inputs)
        nixpkgs;
in {
    nixpkgs.config.allowUnfree = true;
    nix.gc.automatic = true;
    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    nix.settings = {
        experimental-features = [ "flakes" "nix-command" ];
        auto-optimise-store = true;
    };
}
