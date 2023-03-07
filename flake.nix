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
        system = import ./system { inherit inputs lib; };
        lib = nixpkgs.lib.extend (final: _: {
            custom = import ./lib { inherit inputs; lib = final; };
        });

        inherit (lib.custom)
            merge;

        nixosConfigurations = merge [
            (system.x86_64-linux.mkHost ./hosts/Famine [])
            (system.x86_64-linux.mkHost ./hosts/Pestilence [])
            (system.x86_64-linux.mkHost ./hosts/Death [])
        ];

        nixosInstallers = merge [
            (system.x86_64-linux.mkHostIso "Famine")
            (system.x86_64-linux.mkHostIso "Pestilence")
            (system.x86_64-linux.mkHostIso "Death")
        ];

        darwinConfigurations = merge [
            (system.aarch64-darwin.mkHost ./hosts/War [])
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
