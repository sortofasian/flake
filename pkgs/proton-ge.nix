{ stdenv, lib, fetchurl }:
stdenv.mkDerivation rec {
    pname = "proton-ge";
    version = "GE-Proton7-48";

    src = fetchurl {
        url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
        sha256 = "sha256-UoBbizzqd6UNxu701JK4wPe1iHtsMxl3dp3t6VpSZ8M=";
    };

    buildCommand = ''
        mkdir -p $out
        tar -C $out --strip=1 -x -f $src
    '';
}
