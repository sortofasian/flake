{ pkgs, lib, inputs, system, config, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (pkgs)
        makeWrapper
        symlinkJoin;
    inherit (lib)
        makeBinPath;
    inherit (lib.custom)
        flakePath
        switchSystem;
    inherit (inputs)
        agenix;
    inherit (config.custom)
        user;
    ageConfig = config.custom.age;
in {
    options.custom.age = {
        enable = mkOption {
            type = types.bool;
            default = true;
        };
        masterIdentity = mkOption {
            type = types.path;
            default = "${flakePath}/secrets/identities/yubikey.priv";
            description = "Path to an unencrypted age key for \
                decrypting the system identity";
        };
        systemIdentity = mkOption {
            type = types.path;
            default = "${flakePath}/secrets/identities/recipient.age";
            description = "Path to an encrypted age key for \
                decrypting system secrets";
        };
        identityPath = mkOption {
            type = types.path;
            default = "/recipient";
            description = "Where the decrypted system identity is installed";
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
        (mkIf ageConfig.enable {
            environment.systemPackages = [(agenixBin.override {inherit ageBin;})];
            age = {
                inherit ageBin;
                identityPaths = [ ageConfig.identityPath ];
                secrets = {
                    login.file = "${flakePath}/secrets/login.age";
                    ssh.file = "${flakePath}/secrets/ssh.age";
                    ssh.owner = user.name;
                };
            };
        })
        (switchSystem system {
            linux.services.pcscd.enable = mkIf ageConfig.enable true;
        })
    ];
}
