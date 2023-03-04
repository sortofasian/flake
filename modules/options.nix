{ config, options, lib, ... }:
let 
    inherit (lib) mkOption;
    mkOpt = type: default:
        mkOption { inherit type default; };
in {
}
