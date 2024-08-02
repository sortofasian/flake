{ lib, pkgs, config, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (config.custom)
        direnv;
in {
    options.custom.direnv.enable = mkOption {
        type = types.bool;
        default = false;
    };
    config = mkIf direnv.enable {
        environment.systemPackages = with pkgs; [
            direnv
            nix-direnv
            devenv
        ];
        nix.settings = {
            keep-outputs = true;
            keep-derivations = true;
        };
        environment.pathsToLink = [
            "/share/nix-direnv"
        ];
        programs.fish.promptInit = "direnv hook fish | source";
    };
}
