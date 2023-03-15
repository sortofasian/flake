{ inputs, lib, ...}:
let
    inherit (builtins)
        baseNameOf;
    inherit (lib)
        nixosSystem
        removeSuffix;
    inherit (lib.custom)
        switchSystem
        systemSpecificLib;

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
            ]
            ++ (switchSystem system {
                linux = [
                    ./linux.nix
                ];

                darwin = [
                    ./darwin.nix
                ];
            })
            ++ [(import path)]
            ++ modules;
            };
        };

        # TODO: Need to figure out how to name isos with hostname
        mkHostIso = switchSystem system { linux = name: {
            ${system}.${name} = nixosGenerate {
                inherit system;
                format = "install-iso";
                modules = [({ pkgs, config, ... }: {
                    nix.settings.experimental-features = [ "flakes" "nix-command" ];
                    services.pcscd.enable = true;
                    isoImage.squashfsCompression = "lz4";
                    environment.interactiveShellInit = ''sudo \
                        ${import ./installer.nix {inherit pkgs lib name;}}
                    '';
                })];
            };
        }; };

    })
