{ inputs, lib, }:
let
    inherit (lib)
        nixosSystem
        removeSuffix;
    inherit (lib.custom)
        sysCopyDir
        flakePath
        switchSystem;
    inherit (builtins)
        readFile
        baseNameOf
        listToAttrs;
    inherit (inputs.generators)
        nixosGenerate;
    inherit (inputs.darwin.lib)
        darwinSystem;
    inherit (inputs)
        agenix;

    systemSpecificLib = lib: listToAttrs
        (map (system: {
                name = system;
                value = lib {
                    inherit system;
                    pkgs = import inputs.nixpkgs {
                        inherit system;
                        config.allowUnfree = true;
                    };
                };
            })
        [
            "aarch64-linux"
            "aarch64-darwin"
            "x86_64-darwin"
            "x86_64-linux"
        ]);
in {
    inherit systemSpecificLib;

    systems = systemSpecificLib ({system, pkgs}: {
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
                ../cfg-common.nix
                (let rage-yubikey = pkgs.symlinkJoin {
                        name = "rage-yubikey";
                        paths = [ pkgs.rage ];
                        buildInputs = [ pkgs.makeWrapper ];
                        postBuild = ''
                            wrapProgram $out/bin/rage \
                                --prefix PATH : ${lib.makeBinPath [ pkgs.age-plugin-yubikey ]}
                        '';
                    };
                    ageBin = "${rage-yubikey}/bin/rage";
                in {
                    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
                    networking.hostName = name;
                    age = { inherit ageBin; };
                    environment.systemPackages = [(
                        agenix.packages.${system}.default
                            .override { inherit ageBin; }
                    )];
                })
            ]
            ++ (switchSystem system {
                linux = [
                    ../cfg-nixos.nix
                    agenix.nixosModules.default
                ];

                darwin = [
                    ../cfg-darwin.nix
                    agenix.darwinModules.default
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
                modules = [({ pkgs, ... }: {
                    isoImage.squashfsCompression = "lz4";
                    environment.interactiveShellInit = ''sudo \
                        ${pkgs.writeScript "installer"
                        (readFile ../bin/installer.sh)} \
                        ${name} ${sysCopyDir.${system} flakePath}
                    '';
                })];
            };
        }; };

    });
}
