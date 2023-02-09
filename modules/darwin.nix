{ pkgs, config, ... }:
{
    services.nix-daemon.enable = true;
    environment.systemPackages = with pkgs; [
        gnupg
    ];

    environment.shells = [ pkgs.fish ];
    environment.loginShell = pkgs.fish;

    homebrew = {
        enable = true;
        onActivation = {
            upgrade = true;
            autoUpdate = true;
            cleanup = "zap";
        };
    };

    system.activationScripts.applications.text = pkgs.lib.mkForce (''
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
        src="$(/usr/bin/stat -f%Y "$app")"
        cp -Lr "$src" /Applications/Nix\ Apps
    done
    '');

    programs.fish = {
        babelfishPackage = pkgs.babelfish;
        promptInit = ''
            fish_add_path --prepend --global \
                "$HOME/.nix-profile/bin" \
                /nix/var/nix/profiles/default/bin \
                /run/current-system/sw/bin

            any-nix-shell fish | source
            starship init fish | source
        '';
    }; 
}
