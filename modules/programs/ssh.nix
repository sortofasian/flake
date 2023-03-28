{ pkgs, lib, config, system, ... }: let
    inherit (lib.custom)
        switchSystem;
    inherit (config.age)
        secrets;
in switchSystem system {
    linux.config = {
        programs.ssh.extraConfig = ''
            IdentityFile = ${secrets.ssh-yubikey-5.path}
            IdentityFile = ${secrets.ssh-yubikey-5c.path}
        '';
        programs.ssh.startAgent = true;
    };
    darwin.config = {
        environment.systemPackages = [ pkgs.openssh ];
        environment.etc."ssh/ssh_config".text = ''
            IdentityFile = ${secrets.ssh-yubikey-5.path}
            IdentityFile = ${secrets.ssh-yubikey-5c.path}
        '';
        # TODO: test ssh-agent on darwin
        #launchd.user.agents.ssh-agent.command = "${pkgs.openssh}/bin/ssh-agent "
        #        + "-a ${config.environment.variables.XDG_RUNTIME_DIR}/ssh-agent";
        #launchd.user.agents.ssh-agent.serviceConfig = {
        #    RunAtLoad = true;
        #};
    };
}
