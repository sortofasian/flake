{ lib, config, system, ... }: let
    inherit (lib.custom)
        switchSystem;
    inherit (config.age)
        secrets;
in switchSystem system {
    linux.config = {
        programs.ssh.extraConfig = "IdentityFile = ${secrets.ssh.path}";
        programs.ssh.startAgent = true;
    };
}
