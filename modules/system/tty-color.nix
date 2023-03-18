{ lib, system, ... }: let
    inherit (lib.custom)
        switchSystem;
in switchSystem system {
    linux.boot.initrd.preDeviceCommands = let
        color = number: color: ''printf "\e]P${number + color}"'';
    in ''
        ${color "0" "32344a" } # black
        ${color "1" "f7768e" } # red
        ${color "2" "9ece6a" } # green
        ${color "3" "e0af68" } # yellow
        ${color "4" "7aa2f7" } # blue
        ${color "5" "ad8ee6" } # magenta
        ${color "6" "449dab" } # cyan
        ${color "7" "9699a8" } # white
        ${color "8" "444b6a" } # bright black
        ${color "9" "ff7a93" } # bright red
        ${color "A" "b9f27c" } # bright green
        ${color "B" "ff9e64" } # bright yellow
        ${color "C" "7da6ff" } # bright blue
        ${color "D" "bb9af7" } # bright magenta
        ${color "E" "0db9d7" } # bright cyan
        ${color "F" "acb0d0" } # bright white
        clear
    '';
}
