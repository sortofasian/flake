{pkgs, lib, symlinkJoin, makeWrapper, writeText}: let
    config = writeText "rofi.rasi" (builtins.readFile ./rofi.rasi);
    rofi = (pkgs.rofi.override {
      plugins = with pkgs; [
          rofi-calc
          rofi-emoji
      ];
    });
in symlinkJoin {
    name = "rofi";
    paths = [ rofi pkgs.rofi-bluetooth ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/rofi --add-flags "-config ${config}"
    '';
}
