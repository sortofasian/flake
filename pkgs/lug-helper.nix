{ lib
, pkgs
, stdenv
, makeWrapper
, makeDesktopItem
, fetchFromGitHub

, curl
, bash
, gnome
, gnused
, polkit
, gnugrep
, coreutils
, findutils
}:
stdenv.mkDerivation rec {
    pname = "lug-helper";
    version = "v2.3";
    name = "${pname}-${version}";
    src = fetchFromGitHub {
        owner = "starcitizen-lug";
        repo = pname;
        rev = version;
        sha256 = "sha256-nroskmrGaLr9XJA2Ry8lnql8MshlA8kP/qWOO+qyFe4=";
    };

    desktopItem = makeDesktopItem {
        name = pname;
        exec = pname;
        icon = pname;
        categories = ["Game"];
        desktopName = "LUG Helper";
        startupNotify = true;
    };

    nativeBuildInputs = [ makeWrapper ];

    binPath = lib.makeBinPath [
        bash coreutils curl polkit
        gnused gnome.zenity findutils gnugrep 
    ];

    installPhase = ''
        runHook preBuild

        mkdir -p $out/bin
        makeWrapper "$src/lug-helper.sh" "$out/bin/$pname" \
        --prefix PATH : $binPath

        install -Dm755 "$src/lug-logo.png" "$out/share/pixmaps/$pname.png"
        install -Dm755 "$src/lug-lutris-install.json" "$out/share/$pname/lug-lutris-install.json"
        install -Dm755 "$desktopItem/share/applications/$pname.desktop" "$out/share/applications/$pname.desktop"

        runHook postBuild
    '';
} 
