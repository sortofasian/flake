{ lib, config, ... }: let
    inherit (config)
        age;
in {
    options.custom.ssh = {
    };

    config = {
        programs.ssh.extraConfig = "IdentityFile = ${age.secrets.ssh.path}";
        programs.ssh.startAgent = true;
    };
}
