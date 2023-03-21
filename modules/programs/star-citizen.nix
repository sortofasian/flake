{ pkgs, lib, config, system, ... }: let
    inherit (lib)
        mkIf
        types
        mkOption;
    inherit (lib.custom)
        switchSystem;
    inherit (config.custom)
        user
        star-citizen;
in switchSystem system { linux = {
    options.custom.star-citizen.enable = mkOption {
        type = types.bool;
        default = true;
    };

    config = mkIf star-citizen.enable {
        boot.kernel.sysctl = {
            "vm.max_map_count" = 16777216;
            "net.ipv4.neigh.default.gc_thresh1" = 32768;
            "net.ipv4.neigh.default.gc_thresh2" = 65536;
            "net.ipv4.neigh.default.gc_thresh3" = 131072;
        };

        networking.extraHosts = '' 
            # EAC Workaround for Star Citizen
            127.0.0.1 modules-cdn.eac-prod.on.epicgames.com
        '';

        users.users.${user.name}.packages = [(pkgs.stdenv.mkDerivation (let
            inherit (pkgs)
                makeWrapper
                makeDesktopItem
                fetchFromGitHub
                curl
                bash
                gnome
                gnused
                polkit
                gnugrep
                coreutils
                findutils;
            inherit (lib)
                makeBinPath;
        in rec {
            pname = "lug-helper";
            version = "v2.5";
            name = "${pname}-${version}";
            src = fetchFromGitHub {
                owner = "starcitizen-lug";
                repo = pname;
                rev = version;
                sha256 = "sha256-2ikuPqtClkvnC5dCSsf8Jt0HBKI26WY78kI+1o5w4p8=";
            };

            desktopItem = makeDesktopItem {
                name = pname; exec = pname; icon = pname;
                categories = ["Game"];
                desktopName = "LUG Helper";
                startupNotify = true;
            };

            buildInputs = [ makeWrapper ];

            binPath = makeBinPath [
                bash coreutils curl polkit
                gnused gnome.zenity findutils gnugrep
            ];

            installPhase = ''
                runHook preBuild

                mkdir -p $out/bin
                makeWrapper "$src/lug-helper.sh" "$out/bin/$pname" \
                --prefix PATH : $binPath

                install -Dm755 "$src/lug-logo.png" \
                    "$out/share/pixmaps/$pname.png"
                install -Dm755 "$src/lug-lutris-install.json" \
                    "$out/share/$pname/lug-lutris-install.json"
                install -Dm755 "$desktopItem/share/applications/$pname.desktop" \
                    "$out/share/applications/$pname.desktop"

                runHook postBuild
            '';
        }))];
    };
}; }
