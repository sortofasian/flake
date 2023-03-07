{ lib, config, ... }: let
    inherit (lib)
        mkDefault
        mkForce;
in {
    system.stateVersion = 4;

    homebrew = {
        enable = mkDefault true;
        onActivation = {
            upgrade = true;
            autoUpdate = true;
            cleanup = "zap";
        };
    };

    services.nix-daemon.enable = true;
    system.activationScripts.applications.text = mkForce ''
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
            src="$(/usr/bin/stat -f%Y "$app")"
            cp -Lr "$src" /Applications/Nix\ Apps
        done
    '';

    programs.fish.promptInit = ''
        fish_add_path --prepend --global \
            "$HOME/.nix-profile/bin" \
            /nix/var/nix/profiles/default/bin \
            /run/current-system/sw/bin
    '';
}
