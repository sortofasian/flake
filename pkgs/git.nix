{ pkgs, makeWrapper, symlinkJoin }: let
    git = (if pkgs.stdenv.isDarwin then pkgs.git else pkgs.git.override { withLibsecret = true; });
in symlinkJoin {
    name = "gitFull";
    paths = [ git ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/git --add-flags "\
        -c core.askPass=\"\" \
        -c user.email=\"charliesyvertsen06@icloud.com\" \
        -c user.name=\"sortofasian\" \
        -c user.signingKey=\"FF401D7\" \
        -c commit.gpgSign=true \
        -c push.autoSetupRemote=true \
        -c credential.helper=${if pkgs.stdenv.isDarwin
            then "osxkeychain"
            else "${git}/bin/git-credential-libsecret"}"
    '';
}
