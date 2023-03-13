{ inputs, lib, ...}:
let
    inherit (builtins)
        readFile
        baseNameOf;
    inherit (lib)
        nixosSystem
        removeSuffix;
    inherit (lib.custom)
        flakePath
        switchSystem
        systemSpecificLib;

    inherit (inputs)
        agenix;
    inherit (inputs.generators)
        nixosGenerate;
    inherit (inputs.darwin.lib)
        darwinSystem;
in systemSpecificLib ({ system, pkgs, ...}: {
        mkHost = path: modules: let
            name = removeSuffix ".nix" (baseNameOf path);
            configSystem = switchSystem system {
                linux = nixosSystem;
                darwin = darwinSystem;
            };
        in {
            ${name} = configSystem {
            inherit system;
            specialArgs = { inherit lib inputs system; };

            modules = [
                { networking.hostName = name; }
                ./common.nix
                ../secrets
            ]
            ++ (switchSystem system {
                linux = [
                    ./linux.nix
                    agenix.nixosModules.default
                ];

                darwin = [
                    ./darwin.nix
                    agenix.darwinModules.default
                ];
            })
            ++ [(import path)]
            ++ modules;
            };
        };

        # TODO: Need to figure out how to name isos with hostname
        mkHostIso = switchSystem system { linux = name: {
            ${system}.${name} = nixosGenerate (let
                inherit (lib.custom.systemLib.${system}) copyDir;
            in {
                inherit system;
                format = "install-iso";
                modules = [({ pkgs, ... }: {
                    isoImage.squashfsCompression = "lz4";
                    environment.interactiveShellInit = ''sudo \
                        ${pkgs.writeScript "installer"
                        (readFile ../bin/installer.sh)} \
                        ${name} ${copyDir flakePath}
                    '';
                })];
            });
        }; };

    })
