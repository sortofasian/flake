{ lib, config, system, inputs, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (inputs.home-manager)
        nixosModules
        darwinModules;
    inherit (config.custom)
        user;
in {
    imports = switchSystem system {
        linux = [ nixosModules.home-manager ];
        darwin = [ darwinModules.home-manager ];
    };

    options.custom.user = {
        file = mkOption {
            type = types.attrs;
            default = {};
        };
        configFile = mkOption {
            type = types.attrs;
            default = {};
        };
        dataFile = mkOption {
            type = types.attrs;
            default = {};
        };
        mkOutOfStoreSymlink = mkOption {
            type = types.functionTo types.path;
            default = config.home-manager.users.${user.name}.lib.file.mkOutOfStoreSymlink;
        };
    };

    config = mkIf (user.name != "") {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.${user.name} = {
            home.file = user.file;
            home.stateVersion = "22.11";
            xdg.configFile = user.configFile;
            xdg.dataFile = user.dataFile;
        };
    };
}
