{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        generators.url = "github:nix-community/nixos-generators";
        generators.inputs.nixpkgs.follows = "nixpkgs";

        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";

        aagl.url = "github:ezKEa/aagl-gtk-on-nix";
        aagl.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, ... }@inputs: let
        lib = nixpkgs.lib.extend (final: _: {
            custom = import ./lib { inherit inputs; lib = final; };
        });

        system = import ./system { inherit inputs lib; };
        inherit (lib.custom) merge;
    in {
        lib = lib.custom; # only output custom lib

        nixosConfigurations = merge [
            (system.x86_64-linux.mkHost ./hosts/Famine)
            (system.x86_64-linux.mkHost ./hosts/Pestilence)
            (system.x86_64-linux.mkHost ./hosts/Death)
        ];

        darwinConfigurations = merge [
            (system.aarch64-darwin.mkHost ./hosts/War)
        ];

        packages = merge [
            (system.x86_64-linux.mkHostIso "Famine")
            (system.x86_64-linux.mkHostIso "Pestilence")
            (system.x86_64-linux.mkHostIso "Death")
        ];
    };
}
