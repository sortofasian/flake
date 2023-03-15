{ inputs, lib, ...}:
let
    inherit (builtins)
        baseNameOf;
    inherit (lib)
        mkForce
        nixosSystem
        removeSuffix;
    inherit (lib.custom)
        importDir
        switchSystem
        systemSpecificLib;

    inherit (inputs.generators)
        nixosGenerate;
    inherit (inputs.darwin.lib)
        darwinSystem;
in systemSpecificLib ({ system, pkgs, ...}: {
        mkHost = path: let
            name = removeSuffix ".nix" (baseNameOf path);
            configSystem = switchSystem system {
                linux = nixosSystem;
                darwin = darwinSystem;
            };
        in { ${name} = configSystem {
            inherit system;
            specialArgs = { inherit lib inputs system; };
            modules = (importDir ../config) ++ [
                { networking.hostName = name; }
                (import path)
            ];
        }; };

        # TODO: Need to figure out how to name isos with hostname
        mkHostIso = switchSystem system { linux = name: {
            ${system}.${name} = nixosGenerate {
                inherit system;
                format = "install-iso";
                modules = [({ pkgs, config, ... }: {
                    isoImage.squashfsCompression = "lz4";
                    isoImage.isoName = mkForce "${name}.iso";

                    nixpkgs.config.allowUnfree = true;
                    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";
                    nix.settings.experimental-features = [ "flakes" "nix-command" ];

                    services.pcscd.enable = true;
                    environment.interactiveShellInit = ''sudo \
                        ${import ./installer.nix {inherit pkgs lib name;}}
                    '';
                })];
            };
        }; };

    })
