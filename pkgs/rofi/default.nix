{pkgs, lib, symlinkJoin, makeWrapper, writeText}: let
    config = writeText "rofi.rasi" (builtins.readFile ./rofi.rasi);
    rofi = (pkgs.rofi.override {
      plugins = with pkgs; [
          rofi-calc
          rofi-emoji
      ];
    });
    rofi-bluetooth = pkgs.rofi-bluetooth.override { rofi-unwrapped =
        symlinkJoin {name = "rofi"; paths = [ pkgs.rofi ]; buildInputs = [ makeWrapper ];
        postBuild = "wrapProgram $out/bin/rofi --add-flags \"-config ${config}\""; };
    };
in symlinkJoin {
    name = "rofi";
    paths = [ rofi rofi-bluetooth ];
    buildInputs = [ makeWrapper ];
    postBuild = ''
        wrapProgram $out/bin/rofi --add-flags "-config ${config}"
    '';
}
