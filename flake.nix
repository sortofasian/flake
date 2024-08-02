{
    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        np-master.url = "github:NixOS/nixpkgs/master";
        np-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

        darwin.url = "github:lnl7/nix-darwin";
        darwin.inputs.nixpkgs.follows = "nixpkgs";

        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        generators.url = "github:nix-community/nixos-generators";
        generators.inputs.nixpkgs.follows = "nixpkgs";

        agenix.url = "github:ryantm/agenix";
        agenix.inputs.nixpkgs.follows = "nixpkgs";

        apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
        apple-silicon.inputs.nixpkgs.follows = "nixpkgs";

        aagl.url = "github:ezKEa/aagl-gtk-on-nix";
        aagl.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, ... }@inputs: rec {
        lib = (nixpkgs.lib.extend (final: _: {
            custom = import ./lib { inherit inputs; lib = final; };
        })).custom;

        nixosConfigurations = lib.merge [
            (lib.system.x86_64-linux.mkHost ./hosts/Famine)
            (lib.system.x86_64-linux.mkHost ./hosts/Pestilence)
            (lib.system.x86_64-linux.mkHost ./hosts/Death)
            (lib.system.aarch64-linux.mkHost ./hosts/Miniserver)
        ];

        darwinConfigurations = lib.merge [
            (lib.system.aarch64-darwin.mkHost ./hosts/War)
        ];

       packages = lib.merge [
           (lib.system.x86_64-linux.mkHostIso "Famine")
           (lib.system.x86_64-linux.mkHostIso "Pestilence")
           (lib.system.x86_64-linux.mkHostIso "Death")
       ];
    };
}
