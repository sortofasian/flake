{ lib, pkgs, config, inputs, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (config.custom)
        direnv;
    inherit (inputs) devenv;
in {
    options.custom.direnv.enable = mkOption {
        type = types.bool;
        default = false;
    };
    config = mkIf direnv.enable {
        environment.systemPackages = [
            pkgs.direnv
            pkgs.nix-direnv
            devenv.packages.${system}.default
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
