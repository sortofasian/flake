{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";

        generators.url = "github:nix-community/nixos-generators";
        generators.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, darwin, generators, ... }@inputs: let
        lib = nixpkgs.lib.extend (final: _: {
            custom = import ./lib { inherit inputs; lib = final; };
        });

        inherit (lib.custom)
            mkSystems merge;

        systems = mkSystems;

        nixosSystems = merge [
            (systems.x86_64-linux.mkHost ./hosts/Famine [])
            (systems.x86_64-linux.mkHost ./hosts/Pestilence [])
            (systems.x86_64-linux.mkHost ./hosts/Death [])
        ];
        nixosInstallers = merge [
            (systems.x86_64-linux.mkHostIso "Famine")
            (systems.x86_64-linux.mkHostIso "Pestilence")
            (systems.x86_64-linux.mkHostIso "Death")
        ];

        darwinSystems = merge [
            (systems.aarch64-darwin.mkHost ./hosts/War [])
        ];
    in {
        lib = lib.custom;
        nixosConfigurations = nixosSystems;
        darwinConfigurations = darwinSystems;
        packages = nixosInstallers;
    };
}
