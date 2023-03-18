{ lib, system, config, ... }: let
    inherit (lib.generators)
        toGitINI;
    inherit (lib.custom)
        switchSystem;
    inherit (config.age)
        secrets;
    config = {
        url."git@github.com:".insteadOf = [
            "https://github.com/"
            "gh:"
        ];
        user = {
            name = "Charlie Syvertsen";
            email = "charliesyvertsen06@icloud.com";
            signingKey = switchSystem system {
                linux = secrets.ssh.path;
                darwin = "~/.ssh/identity.pub";
            };
        };
        gpg.format = "ssh";
        tag.gpgSign = true;
        commit.gpgSign = true;
        pull.rebase = true;
        push.autoSetupRemote = true;
        fetch.prune = true;
        init.defaultBranch = "main";
        status.short = true;
    };
in switchSystem system ({
    linux.programs.git = { inherit config; };
    darwin.variables.GIT_CONFIG_SYSTEM = toGitINI config;
})
