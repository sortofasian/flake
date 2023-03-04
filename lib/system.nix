{ inputs, lib, }:
let
    inherit (lib)
        filterAttrs
        removeSuffix;
    inherit (lib.custom)
        flakePath
        switchSystem;
    inherit (builtins)
        readFile
        baseNameOf
        listToAttrs;
    inherit (inputs.generators)
        nixosGenerate;

    systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
    ];
in {
    mkSystems = let
        mkSystem = system:
        let
            pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            #overlays = self.overlays;
            };

            copyDir = dir:
            pkgs.runCommand (baseNameOf dir) { src = dir; }
            "mkdir $out; cp -r $src/* $out";
        in filterAttrs (_: v: v != null) {
            mkHost = path: modules:
            let
                name = removeSuffix ".nix" (baseNameOf path);
                configSystem = switchSystem system {
                linux = lib.nixosSystem;
                darwin = inputs.darwin.lib.darwinSystem;
                };
            in {
                ${name} = configSystem {
                inherit system;
                specialArgs = { inherit lib inputs system; };
                modules = [
                    #({ nixpkgs.pkgs = pkgs; })
                    { networking.hostName = name; }
                    ../cfg-common.nix
                    (switchSystem system {
                    linux = ../cfg-nixos.nix;
                    darwin = ../cfg-darwin.nix;
                    })
                    (import path)
                ] ++ modules;
                };
            };

            mkHostIso = switchSystem system {
            linux = name: {
                ${system}.${name} = nixosGenerate {
                    inherit system;
                    format = "install-iso";
                    filename = "${name}.iso";
                    modules = [({ pkgs, ... }: {
                        isoImage.squashfsCompression = "lz4";
                        environment.interactiveShellInit = ''sudo \
                            ${pkgs.writeScript "installer"
                            (readFile ../bin/installer.sh)} \
                            ${name} ${copyDir flakePath}
                        '';
                    })];
                };
            };
            };
        };
    in listToAttrs (map (system: {
        name = system;
        value = mkSystem system;
    }) systems);
}
