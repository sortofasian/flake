{ pkgs, lib, inputs, system, config, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (pkgs)
        rage
        makeWrapper
        symlinkJoin
        age-plugin-yubikey;
    inherit (lib)
        makeBinPath;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        age;
    inherit (inputs)
        agenix;

    agenixBin = agenix.packages.${system}.default;
    ageBin = "${rage-yubikey}/bin/rage";
    rage-yubikey = symlinkJoin {
        name = "rage-yubikey"; paths = [ rage ];
        buildInputs = [makeWrapper];
        postBuild = ''wrapProgram $out/bin/rage \
            --prefix PATH : ${makeBinPath [age-plugin-yubikey]}'';
    };
in {
    options.custom.age = {
        enable = mkOption {
            type = types.bool;
            default = true;
        };
        yubikeyPath = mkOption {
            type = types.path;
            default = ./yubikey.id;
        };
        encryptedIdentity = mkOption {
            type = types.path;
            default = ./recipient.age;
        };
        identityPath = mkOption {
            type = types.path;
            default = "/recipient";
        };
    };

    imports = (switchSystem system {
        linux = [agenix.nixosModules.default];
        darwin = [agenix.darwinModules.default];
    });

    config = {
        age.ageBin = ageBin;
        environment.systemPackages = [(
            agenixBin.override {inherit ageBin;}
        )];

        age = {
            identityPaths = [ age.identityPath ];
            secrets = {
                login.file = ./secrets/login.age;
            };
        };
    };
}
