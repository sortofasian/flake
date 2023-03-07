{ pkgs, lib, inputs, system, ... }: let
    inherit (lib)
        mkDefault;
    inherit (lib.custom)
        importDir;
    inherit (pkgs)
        rage
        makeWrapper
        symlinkJoin
        age-plugin-yubikey;
    inherit (inputs)
        agenix
        nixpkgs;

    rage-yubikey = symlinkJoin {
        name = "rage-yubikey";
        paths = [ rage ];
        buildInputs = [ makeWrapper ];
        postBuild = ''
            wrapProgram $out/bin/rage \
                --prefix PATH : ${lib.makeBinPath [ age-plugin-yubikey ]}
        '';
    };
    ageBin = "${rage-yubikey}/bin/rage";

in {
    nix.nixPath = [ "nixpkgs=${nixpkgs}" ];
    nix.gc.automatic = mkDefault true;
    nix.settings = {
        experimental-features = [ "flakes" "nix-command" ];
        auto-optimise-store = mkDefault true;
    };
    environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

    age.ageBin = ageBin;
    age.identityPaths = [ ./secrets/identity ];
    environment.systemPackages = [(
        agenix.packages.${system}.default
            .override { inherit ageBin; }
    )];


    imports = importDir ../configs;
}
