{ pkgs, lib, inputs, system, config, ... }: let
    inherit (lib)
        mkIf
        types
        mkMerge
        mkOption;
    inherit (lib)
        makeBinPath
        concatStringsSep;
    inherit (lib.custom)
        flakePath
        switchSystem;
    inherit (inputs)
        agenix;
    ageConfig = config.custom.age;

    masterIdentities = [
        ./age-yubikey-5
        ./age-yubikey-5c
        "/backup-identity"
    ];
in {
    options.custom.age = {
        enable = mkOption {
            type = types.bool;
            default = true;
        };
        systemIdentity = {
            file = mkOption {
                type = types.path;
            };
            dest = mkOption {
                type = types.path;
                default = "/etc/system-age-key";
            };
        };
    };

    imports = (switchSystem system {
        linux = [agenix.nixosModules.default ./secrets.nix];
        darwin = [agenix.darwinModules.default ./secrets.nix];
    }) ++ [ ./secrets.nix ];

    config = mkIf ageConfig.enable (mkMerge [
        { age.identityPaths = [ ageConfig.systemIdentity.dest ]; }
        (switchSystem system (let recipientInstall = ''
            echo "Recipient key is missing, running install script"
            for id in ${concatStringsSep " " masterIdentities}; do
                age -d \
                    -i $id \
                    -o ${ageConfig.systemIdentity.dest} \
                    ${ageConfig.systemIdentity.file}
            done
            chmod 400 ${ageConfig.systemIdentity.dest}
            chown root ${ageConfig.systemIdentity.dest}
        ''; in {
            #TODO: test switching tty in activation; would it work in terminal emulator?
            #system.activationScripts._check-recipient.text = "openvt -sw ${pkgs.bash}";
            linux.services.pcscd.enable = mkIf ageConfig.enable true;
            linux.systemd.services.check-recipient = {
                wantedBy = [ "default.target" ];
                after = [ "default.target" ];
                path = with pkgs; [ age age-plugin-yubikey kbd nixos-rebuild ];
                serviceConfig.Restart = "on-failure";
                unitConfig.ConditionPathExists = "!${ageConfig.systemIdentity.dest}";
                script = ''
                    openvt -sw ${pkgs.writeScript "install-recipient" ''
                        ${recipientInstall}
                        echo "Updating system config"
                        nixos-rebuild switch --flake ${flakePath}
                    ''}
                '';
            };

            darwin.system.activationScripts.preActivation.text = ''
                echo "installing recipient age key..."
                export PATH=${makeBinPath (with pkgs; [
                    alacritty age age-plugin-yubikey
                ])}:$PATH

                if [ ! -f ${ageConfig.systemIdentity.dest} ]; then
                    #TODO: find way to make this terminal agnostic
                    alacritty -e ${pkgs.writeScript "install-recipient" recipientInstall}
                fi
            '';
        }))
    ]);
}
