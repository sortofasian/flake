{
    inputs = {
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
        nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

        hyprland.url = "github:hyprwm/Hyprland";
    };

    outputs = { self, nixpkgs-unstable, nixpkgs-stable, darwin, hyprland, ... } :

    let
        overlays = {pkgs, stable, ...}: { nixpkgs.overlays = [
            (import ./overlays.nix { inherit stable; inherit (pkgs) system; } )
        ];};

        inherit (darwin.lib) darwinSystem;
        inherit (nixpkgs-unstable.lib) nixosSystem;

        commonModules = [ overlays modules/common.nix ];
        nixosModules = commonModules ++ [ hyprland.nixosModules.default modules/nixos.nix ];
        darwinModules = commonModules ++ [ modules/darwin.nix ];
    in {
        nixosConfigurations = let common = nixosModules; in {
            Famine = nixosSystem {
                system = "x86_64-linux";
                specialArgs = { stable = nixpkgs-stable; };
                modules = common ++ [
                    ./hosts/famine/default.nix
                ];
            };
        };

        darwinConfigurations = let common = darwinModules; in {
            War = darwinSystem {
                system = "aarch64-darwin";
                specialArgs = { stable = nixpkgs-stable; };
                modules = common ++ [
                    ./hosts/war/default.nix
                ];
            };
        };

        lib = import ./lib;

        templates.dev = {
            path = ./templates/dev;
            description = "Flake for use with `nix shell`";
        };
    };
}
