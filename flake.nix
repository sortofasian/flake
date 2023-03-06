{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";

        generators.url = "github:nix-community/nixos-generators";
        generators.inputs.nixpkgs.follows = "nixpkgs";

        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, darwin, generators, ... }@inputs: let
        lib = nixpkgs.lib.extend (final: _: {
            custom = import ./lib { inherit inputs; lib = final; };
        });

        inherit (lib.custom)
            systems merge;

        nixosConfigurations = merge [
            (systems.x86_64-linux.mkHost ./hosts/Famine [])
            (systems.x86_64-linux.mkHost ./hosts/Pestilence [])
            (systems.x86_64-linux.mkHost ./hosts/Death [])
        ];

        nixosInstallers = merge [
            (systems.x86_64-linux.mkHostIso "Famine")
            (systems.x86_64-linux.mkHostIso "Pestilence")
            (systems.x86_64-linux.mkHostIso "Death")
        ];

        darwinConfigurations = merge [
            (systems.aarch64-darwin.mkHost ./hosts/War [])
        ];
        
        packages = merge [
            nixosInstallers
        ];
    in {
        lib = lib.custom; # only output custom lib
        inherit packages;
        inherit nixosConfigurations;
        inherit darwinConfigurations;
    };
}
