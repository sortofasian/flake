{ pkgs, lib, inputs, system, config, name, ... }: let
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
                    pam-u2f.file = "${flakePath}/secrets/ssh.age";
                    pam-u2f.owner = user.name;
                    ssh.file = "${flakePath}/secrets/ssh.age";
                    ssh.owner = user.name;
                };
            };
        })
        (switchSystem system {
            linux.services.pcscd.enable = mkIf ageConfig.enable true;
            linux.systemd.services.check-recipient = {
                wantedBy = [ "default.target" ];
                after = [ "default.target" ];
                path = [ pkgs.age-plugin-yubikey pkgs.kbd pkgs.age pkgs.nixos-rebuild ];
                serviceConfig.Restart = "on-failure";
                script = ''
                    if [ -f ${ageConfig.identityPath} ]; then exit 0; fi
                    openvt -sw ${pkgs.writeScript "install-recipient" ''
                        age -d \
                            -i ${ageConfig.masterIdentity} \
                            -o ${ageConfig.identityPath} \
                               ${ageConfig.systemIdentity}
                        chmod 400 ${ageConfig.identityPath}
                        chown root:root ${ageConfig.identityPath}
                        nixos-rebuild switch --flake ${flakePath}
                    ''}
                '';
            };
        })
    ];
}
