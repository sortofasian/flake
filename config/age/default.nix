{ pkgs, lib, inputs, system, config, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkForce
        mkOption;
    inherit (pkgs)
        makeWrapper
        symlinkJoin;
    inherit (lib)
        makeBinPath;
    inherit (lib.custom)
        switchSystem;
    inherit (inputs)
        agenix;
    ageConfig = config.custom.age;
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

    config = let
        agenixBin = agenix.packages.${system}.default;
        ageBin = "${age-yubikey}/bin/age";
        age-yubikey = symlinkJoin {
            name = "age-yubikey"; paths = [ pkgs.age ];
            buildInputs = [ makeWrapper ];
            postBuild = ''wrapProgram $out/bin/age \
                --prefix PATH : ${makeBinPath [ pkgs.age-plugin-yubikey ]}'';
        };
    in mkMerge [
        #https://github.com/ryantm/agenix/blob/main/modules/age.nix#L235
        (mkIf (!ageConfig.enable) { age.secrets = mkForce {}; })
        (mkIf ageConfig.enable {
            services.pcscd.enable = true;
            environment.systemPackages = [(agenixBin.override {inherit ageBin;})];
            age = {
                inherit ageBin;
                identityPaths = [ ageConfig.identityPath ];
                secrets = {
                    login.file = ./secrets/login.age;
                };
            };
        })
    ];
}
