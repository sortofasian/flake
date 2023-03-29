{ pkgs, lib, config, inputs, system, ... }: let
    inherit (inputs)
        nixpkgs;
    inherit (lib)
        mkForce;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user;
in {
    nixpkgs.config.allowUnfree = true;
    nix.gc.automatic = true;
    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
    nix.settings = let users = [ "root" user.name ]; in {
        experimental-features = [ "flakes" "nix-command" ];
        auto-optimise-store = true;
        trusted-users = users;
        allowed-users = users;
    };
} // switchSystem system {
    linux.system.stateVersion = "23.05";
    darwin = {
        system.stateVersion = 4;

        services.nix-daemon.enable = true;
        homebrew.enable = true;
        homebrew.onActivation = {
            upgrade = true;
            autoUpdate = true;
            cleanup = "zap";
        };
        system.activationScripts.applications.text = mkForce ''
            rm -rf /Applications/Nix\ Apps
            mkdir -p /Applications/Nix\ Apps
            for app in $(find ${config.system.build.applications}/Applications -maxdepth 1 -type l); do
                src="$(/usr/bin/stat -f%Y "$app")"
                cp -Lr "$src" /Applications/Nix\ Apps
            done
        '';
    };
}
