{ lib, ... }: let
    inherit (lib)
        mkDefault;
    inherit (lib.custom)
        importDir;
in {
    imports = importDir ./modules;

    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    nix.gc.automatic = mkDefault true;
    nix.settings = {
        experimental-features = [ "flakes" "nix-command" ];
        auto-optimise-store = mkDefault true;
    };
}
